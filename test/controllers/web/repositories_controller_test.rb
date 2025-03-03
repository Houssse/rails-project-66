# frozen_string_literal: true

module Web
  class RepositoriesControllerTest < ActionDispatch::IntegrationTest
    def setup
      @user = users(:one)
      sign_in(@user)
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
