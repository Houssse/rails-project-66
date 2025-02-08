# frozen_string_literal: true

module Repository
  class CheckRepositoryJob < ApplicationJob
    queue_as :default

    def perform(check_id)
      check = Repository::Check.find(check_id)
      check.start_cloning!

      repo_dir = Rails.root.join('tmp', 'repos', check.repository.full_name)

      if Dir.exist?(repo_dir)
        update_repository(repo_dir)
      else
        clone_repository(repo_dir, check.repository.full_name)
      end

      check.update!(commit_id: latest_commit_id(repo_dir))
      check.complete!
    rescue StandardError => e
      check.fail!
      Rails.logger.error("Repository cloning failed: #{e.message}")
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
  end
end
