# frozen_string_literal: true

module Web
  class RepositoriesControllerTest < ActionDispatch::IntegrationTest
    def setup
      @user = users(:one)
      sign_in(@user)
    end

    test 'GET #new returns success status' do
      get new_repository_url

      assert_response :success
    end

    test 'GET #new assigns @repos' do
      get new_repository_url

      assert_not_nil assigns(:repos)
    end

    test 'GET #new assigns @repository' do
      get new_repository_url

      assert_not_nil assigns(:repository)
    end

    test 'GET #new assigns a new Repository object to @repository' do
      get new_repository_url

      assert_predicate assigns(:repository), :new_record?
    end

    test 'should create repository and enqueue job' do
      params = { repository: { github_id: 123 } }

      post(repositories_path, params:)

      new_repository = ::Repository.find_by(github_id: 123)

      assert new_repository

      assert_enqueued_with(
        job: ::RepositoryJobs::UpdateInfoRepositoryJob,
        args: [new_repository.id],
        queue: 'default'
      )
    end
  end
end
