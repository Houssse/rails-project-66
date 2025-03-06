# frozen_string_literal: true

module Web
  class RepositoriesControllerTest < ActionDispatch::IntegrationTest
    def setup
      @user = users(:one)
      sign_in(@user)
    end

    # Тесты для экшена new
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

    # Тесты для экшена create
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

    # Тесты для экшена index
    test 'GET #index returns success status' do
      get repositories_url

      assert_response :success
    end

    test 'GET #index assigns @repositories' do
      get repositories_url

      assert_not_nil assigns(:repositories)
      assert_equal current_user.repositories.count, assigns(:repositories).count
    end

    # Тесты для экшена show
    test 'GET #show returns success status' do
      repository = current_user.repositories.create(github_id: 123)
      get repository_url(repository)

      assert_response :success
    end

    test 'GET #show assigns @repository' do
      repository = current_user.repositories.create(github_id: 123)
      get repository_url(repository)

      assert_equal repository, assigns(:repository)
    end

    test 'GET #show assigns @checks' do
      repository = current_user.repositories.create(github_id: 123)
      3.times { repository.checks.create }
      get repository_url(repository)

      assert_not_nil assigns(:checks)
      assert_equal 3, assigns(:checks).count
    end
  end
end
