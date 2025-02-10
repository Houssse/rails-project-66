# frozen_string_literal: true

module Repository
  class ApplicationJob < ApplicationJob
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
