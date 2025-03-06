# frozen_string_literal: true

module Web
  module Repository
    class ChecksControllerTest < ActionDispatch::IntegrationTest
      def setup
        @user = users(:one)
        @repository = repositories(:one)
        sign_in(@user)
      end

      test 'should create check' do
        assert_difference('::Repository::Check.count') do
          post repository_checks_path(@repository)
        end

        check = ::Repository::Check.last

        assert_enqueued_with(job: ::RepositoryJobs::CheckRepositoryJob, args: [check.id])
      end

      test 'GET #show assigns the requested check to @check' do
        check = @repository.checks.create!
        get repository_check_path(@repository, check)

        assert_response :success
        assert_equal check, assigns(:check)
      end
    end
  end
end
