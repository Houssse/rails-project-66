# frozen_string_literal: true

class RepositoryManagerStub
  def initialize(check)
    @check = check
  end

  def prepare_repository
    @check.start_cloning!
    @check.update!(commit_id: 'fake_commit_id')
  end

  def repo_dir
    Rails.root.join('tmp', 'test_repo_dir')
  end
end