# frozen_string_literal: true

require_relative 'github_repository_stub'

class GithubClientStub
  def initialize(*); end

  def repos(_)
    GithubRepositoryStub.new(
      name: 'test-repo',
      full_name: 'user/test-repo',
      language: 'Ruby',
      clone_url: 'https://github.com/user/test-repo.git',
      ssh_url: 'git@github.com:user/test-repo.git'
    )
  end

  def hooks(_repo)
    []
  end

  def create_hook(_repo, _name, _config, _options); end
end
