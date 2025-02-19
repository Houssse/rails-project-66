# frozen_string_literal: true

module RepositoryJobs
  class CreateWebhookJob < RepositoryJobs::ApplicationJob
    queue_as :default

    def perform(repository_id, user_id)
      repository = Repository::Repo.find(repository_id)
      user = User.find(user_id)

      WebhookCreator.new(repository, user).call
    end
  end
end
