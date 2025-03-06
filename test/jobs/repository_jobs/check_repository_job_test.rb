# frozen_string_literal: true

require 'test_helper'

module RepositoryJobs
  class CheckRepositoryJobTest < ActiveJob::TestCase
    def setup
      @check_rb = repository_checks(:one)
      @check_js = repository_checks(:two)
    end

    test "enqueues CheckJavascriptJob for JavaScript repository" do
      assert_enqueued_with(job: CheckJavascriptJob, args: [@check_js.id]) do
        CheckRepositoryJob.perform_now(@check_js.id)
      end
    end

    test "enqueues CheckRubyJob for Ruby repository" do
      assert_enqueued_with(job: CheckRubyJob, args: [@check_rb.id]) do
        CheckRepositoryJob.perform_now(@check_rb.id)
      end
    end
  end
end
