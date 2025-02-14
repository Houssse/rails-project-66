# frozen_string_literal: true

module Repository
  class CheckRubyJob < Repository::ApplicationJob
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
      run_rubocop(check, repo_dir)

      check.complete!

      RepositoryMailer.check_report(check.repository.user, check).deliver_later if !check.passed || check.offenses.any?
    rescue StandardError => e
      check.fail!
      Rails.logger.error("Repository check failed: #{e.message}")
    end

    private

    def run_rubocop(check, repo_dir)
      rubocop_config = Rails.root.join('lib/linters/.rubocop.yml')
      stdout, _, status = Open3.capture3("rubocop --config #{rubocop_config} --format json #{repo_dir}")

      if status.success?
        check.update!(passed: true)
      else
        check.update!(passed: false)
      end

      offenses_data = JSON.parse(stdout)
      save_offenses(check, offenses_data)
    end

    def save_offenses(check, offenses_data)
      offenses_data['files'].each do |file|
        file_path = file['path']
        file['offenses'].each do |offense|
          check.offenses.create!(
            file_path: file_path,
            message: offense['message'],
            rule_id: offense['cop_name'],
            line: offense['location']['start_line'],
            column: offense['location']['start_column']
          )
        end
      end
    end
  end
end
