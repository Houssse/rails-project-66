# frozen_string_literal: true

class GithubClientStub
  def repos
    [
      { id: 123, name: 'test_repo', full_name: 'user/test_repo', language: 'Ruby' }
    ]
  end

  def repo(_id)
    { id: 123, name: 'test_repo', full_name: 'user/test_repo', language: 'Ruby' }
  end

  def hooks(_repo)
    []
  end

  def create_hook(_repo, _name, _config, _options); end
end
