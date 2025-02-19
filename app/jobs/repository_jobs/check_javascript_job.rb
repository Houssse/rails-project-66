# frozen_string_literal: true

module RepositoryJobs
  class CheckJavascriptJob < RepositoryJobs::ApplicationJob
    queue_as :default

    def perform(check_id)
      check = Repository::Check.find(check_id)
      check.start_cloning!

      repo_dir = Rails.root.join('storage', 'repositories', check.repository.full_name)

      if Dir.exist?(repo_dir)
        update_repository(repo_dir)
      else
        clone_repository(repo_dir, check.repository.full_name)
      end

      check.update!(commit_id: latest_commit_id(repo_dir))

      check.start_checking!
      run_eslint(check, repo_dir)

      check.complete!

      RepositoryMailer.check_report(check.repository.user, check).deliver_later if !check.passed || check.offenses.any?
    rescue StandardError => e
      check.fail!
      Rails.logger.error("Repository check failed: #{e.message}")
    end

    private

    def run_eslint(check, repo_dir)
      stdout_str = +''
      stderr_str = +''

      Open3.popen3(
        "yarn eslint --config lib/linters/eslint.config.js --format json \"#{repo_dir}/**/*.js\""
      ) do |_stdin, stdout, stderr, wait_thr|
        stdout_thread = Thread.new { stdout.each { |line| stdout_str << line } }
        stderr_thread = Thread.new { stderr.each { |line| stderr_str << line } }

        stdout_thread.join
        stderr_thread.join

        exit_status = wait_thr.value
        check.update!(passed: exit_status.success?)
      end

      cleaned_output = stdout_str.lines
                                 .reject { |line| line.strip.start_with?('info') }
                                 .drop_while { |line| !line.strip.start_with?('[') }
                                 .join

      if cleaned_output.strip.empty?
        Rails.logger.error("Failed to extract JSON from ESLint output. stderr: #{stderr_str}")
        return
      end

      save_eslint_offenses(check, cleaned_output)
    end

    def save_eslint_offenses(check, eslint_output)
      begin
        offenses_data = JSON.parse(eslint_output)
      rescue JSON::ParserError => e
        Rails.logger.error("Failed to parse ESLint output: #{e.message}")
        Rails.logger.debug { "Raw ESLint output: #{eslint_output}" }
        return
      end

      offenses_data.each do |file|
        file_path = file['filePath']
        file['messages'].each do |offense|
          check.offenses.create!(
            file_path: file_path,
            message: offense['message'],
            rule_id: offense['ruleId'],
            line: offense['line'],
            column: offense['column']
          )
        end
      end
    end
  end
end
