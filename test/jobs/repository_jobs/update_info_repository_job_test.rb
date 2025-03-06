# test/jobs/repository_jobs/update_info_repository_job_test.rb
# frozen_string_literal: true

require 'test_helper'

module RepositoryJobs
  class UpdateInfoRepositoryJobTest < ActiveJob::TestCase
    def setup
      @repository = repositories(:one)
    end

    test 'perform updates repository information from GithubClientStub' do
      RepositoryJobs::UpdateInfoRepositoryJob.perform_now(@repository.id)

      @repository.reload

      assert_equal 'test-repo', @repository.name
      assert_equal 'user/test-repo', @repository.full_name
    end

    test 'perform enqueues CheckRepositoryJob' do
      assert_enqueued_jobs 1 do
        RepositoryJobs::UpdateInfoRepositoryJob.perform_now(@repository.id)
      end
    end
  end
end
