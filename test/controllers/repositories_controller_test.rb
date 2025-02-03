# frozen_string_literal: true

require 'test_helper'
require 'minitest/mock'

class RepositoriesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @github_repo = {
      id: 123456,
      name: 'test-repo',
      full_name: 'test-user/test-repo',
      language: 'Ruby',
      clone_url: 'https://github.com/test-user/test-repo.git',
      ssh_url: 'git@github.com:test-user/test-repo.git'
    }

    @client_mock = Minitest::Mock.new
    @client_mock.expect :repo, @github_repo, [@github_repo[:id]]

    Octokit::Client.stub :new, @client_mock do
      sign_in(@user)
    end
  end

  test 'should create repository and redirect' do
    assert_difference '@user.repositories.count', 1 do
      post repositories_path, params: { repository: { github_id: @github_repo[:id] } }
    end

    assert_redirected_to repositories_path
  end
end
