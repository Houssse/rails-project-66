# frozen_string_literal: true

class GithubClientStub
  def initialize(*); end

  def repos
    [
      GithubRepositoryStub.new(
        id: 123,
        name: 'test-repo',
        full_name: 'user/test-repo',
        language: 'Ruby',
        clone_url: 'https://github.com/user/test-repo.git',
        ssh_url: 'git@github.com:user/test-repo.git'
      )
    ]
  end

  def hooks(_repo)
    []
  end

  def create_hook(_repo, _name, _config, _options); end
end
