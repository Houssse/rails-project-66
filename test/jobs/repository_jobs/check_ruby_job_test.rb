# frozen_string_literal: true

require 'test_helper'

module RepositoryJobs
  class CheckRubyJobTest < ActiveJob::TestCase
    def setup
      @check = repository_checks(:one)

      @offenses_data = {
        'files' => [
          {
            'path' => 'app/models/user.rb',
            'offenses' => [
              {
                'message' => 'Avoid using puts',
                'cop_name' => 'Style/AvoidPuts',
                'location' => { 'start_line' => 10, 'start_column' => 5 }
              }
            ]
          }
        ]
      }
    end

    def teardown
      BashRunnerStub.stub_command(nil)
    end

    test 'perform updates check state to finished' do
      RepositoryJobs::CheckRubyJob.perform_now(@check.id)

      @check.reload

      assert_equal 'finished', @check.aasm_state
    end

    test 'perform marks check as passed when rubocop succeeds' do
      RepositoryJobs::CheckRubyJob.perform_now(@check.id)

      @check.reload

      assert_predicate @check, :passed?
      assert_empty @check.offenses
    end

    test 'perform does not enqueue email when check passes and has no offenses' do
      RepositoryJobs::CheckRubyJob.perform_now(@check.id)

      assert_no_enqueued_emails
    end

    test 'perform marks check as failed when rubocop finds issues' do
      BashRunnerStub.stub_command('rubocop', stdout: @offenses_data.to_json, exit_status: 1)

      RepositoryJobs::CheckRubyJob.perform_now(@check.id)

      @check.reload

      assert_not @check.passed?
      assert_equal 1, @check.offenses.count
    end

    test 'perform enqueues email when rubocop finds issues' do
      BashRunnerStub.stub_command('rubocop', stdout: @offenses_data.to_json, exit_status: 1)

      RepositoryJobs::CheckRubyJob.perform_now(@check.id)

      assert_enqueued_emails 1
    end
  end
end
