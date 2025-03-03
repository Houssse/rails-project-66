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
    end
  end
end
