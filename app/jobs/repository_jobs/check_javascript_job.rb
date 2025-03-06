# frozen_string_literal: true

module RepositoryJobs
  class CheckJavascriptJob < RepositoryJobs::ApplicationJob
    queue_as :default

    def perform(check_id)
      check = Repository::Check.find(check_id)

      repository_manager = ApplicationContainer[:repository_manager].new(check)
      repository_manager.prepare_repository

      check.start_checking!
      run_eslint(check, repository_manager.repo_dir)

      check.finished!

      RepositoryMailer.check_report(check.repository.user, check).deliver_later if !check.passed || check.offenses.any?
    rescue StandardError => e
      check.fail!
      Rails.logger.error("Repository check failed: #{e.message}")
    end

    private

    def run_eslint(check, repo_dir)
      command = "yarn eslint --config lib/linters/eslint.config.js --format json \"#{repo_dir}/**/*.js\""

      bash_runner = ApplicationContainer[:bash_runner]
      stdout, exit_status = bash_runner.execute(command)

      check.update!(passed: exit_status.zero?)

      cleaned_output = clean_eslint_output(stdout)

      if cleaned_output.strip.empty?
        Rails.logger.error('ESLint output is empty or invalid.')
        return
      end

      save_eslint_offenses(check, cleaned_output)
    rescue JSON::ParserError => e
      Rails.logger.error("Failed to parse ESLint output: #{e.message}")
    end

    def clean_eslint_output(stdout)
      stdout.lines
            .reject { |line| line.strip.start_with?('info') }
            .drop_while { |line| !line.strip.start_with?('[') }
            .join
    end

    def save_eslint_offenses(check, eslint_output)
      offenses_data = JSON.parse(eslint_output)

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
    rescue JSON::ParserError => e
      Rails.logger.error("Failed to parse ESLint output: #{e.message}")
      Rails.logger.debug { "Raw ESLint output: #{eslint_output}" }
    end
  end
end
