# frozen_string_literal: true

module RepositoryJobs
  class CheckRepositoryJob < RepositoryJobs::ApplicationJob
    queue_as :default

    def perform(check_id)
      check = Repository::Check.find_by(id: check_id)
      return unless check

      repository = check.repository
      case repository.language
      when 'javascript'
        CheckJavascriptJob.perform_later(check.id)
      when 'ruby'
        CheckRubyJob.perform_later(check.id)
      end
    end
  end
end
