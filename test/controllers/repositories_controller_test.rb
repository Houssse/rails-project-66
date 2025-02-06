# frozen_string_literal: true

require 'test_helper'

class RepositoriesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    sign_in(@user)
  end

  test 'should create repository' do
    assert_difference('Repository.count', 1) do
      post repositories_path,
           params: { repository: { github_id: 123, name: 'test_repo', full_name: 'user/test_repo', language: 'Ruby' } }
    end
    assert_equal 'test_repo', Repository.last.name
  end
end
