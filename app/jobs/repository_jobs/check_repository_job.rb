# frozen_string_literal: true

module RepositoryJobs
  class CheckRepositoryJob < RepositoryJobs::ApplicationJob
    queue_as :default

    def perform(check_id)
      case repository.language
      when 'javascript'
        Repository::CheckJavascriptJob.perform_later(check.id)
      when 'ruby'
        Repository::CheckRubyJob.perform_later(check.id)
      end
    end
  end
end
