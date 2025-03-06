# frozen_string_literal: true

class RepositoryManager
  def initialize(check)
    @check = check
    @repo_dir = Rails.root.join('storage', 'repositories', @check.repository.full_name)
  end

  def prepare_repository
    @check.start_cloning!

    if Dir.exist?(@repo_dir)
      update_repository
    else
      clone_repository
    end

    @check.update!(commit_id: latest_commit_id)
  end

  def repo_dir
    @repo_dir
  end

  private

  def clone_repository
    FileUtils.rm_rf(@repo_dir)
    system("git clone https://github.com/#{@check.repository.full_name}.git #{@repo_dir}")
  end

  def update_repository
    system("git -C #{@repo_dir} fetch --all")
    system("git -C #{@repo_dir} reset --hard origin/main")
  end

  def latest_commit_id
    stdout, = Open3.capture2("git -C #{@repo_dir} rev-parse HEAD")
    stdout.strip
  end
end
