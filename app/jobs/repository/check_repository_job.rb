# frozen_string_literal: true

# app/jobs/check_repository_job.rb
module Repository
  class CheckRepositoryJob < ApplicationJob
    queue_as :default

    def perform(check_id)
      check = Repository::Check.find(check_id)
      check.start_cloning!

      repo_dir = Rails.root.join('tmp', 'repos', check.repository.full_name)

      # Клонирование или обновление репозитория
      if Dir.exist?(repo_dir)
        update_repository(repo_dir)
      else
        clone_repository(repo_dir, check.repository.full_name)
      end

      # Получаем последний коммит
      check.update!(commit_id: latest_commit_id(repo_dir))

      # Запуск Rubocop и сохранение замечаний
      check.start_checking!
      run_rubocop(check, repo_dir)

      check.complete!
    rescue StandardError => e
      check.fail!
      Rails.logger.error("Repository check failed: #{e.message}")
    end

    private

    def clone_repository(repo_dir, repo_full_name)
      FileUtils.rm_rf(repo_dir)
      system("git clone https://github.com/#{repo_full_name}.git #{repo_dir}")
    end

    def update_repository(repo_dir)
      system("git -C #{repo_dir} fetch --all")
      system("git -C #{repo_dir} reset --hard origin/main")
    end

    def latest_commit_id(repo_dir)
      stdout, = Open3.capture2("git -C #{repo_dir} rev-parse HEAD")
      stdout.strip
    end

    def run_rubocop(check, repo_dir)
      rubocop_config = Rails.root.join('.rubocop.yml')
      stdout, stderr, status = Open3.capture3("rubocop --config #{rubocop_config} --format json #{repo_dir}")

      if status.success?
        check.update!(passed: true)
      else
        check.update!(passed: false)
      end

      # Парсим JSON-вывод Rubocop
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
