# frozen_string_literal: true

require 'dry/container'

class ApplicationContainer
  extend Dry::Container::Mixin

  if Rails.env.test?
    require Rails.root.join('test/support/github_client_stub')
    require Rails.root.join('test/support/bash_runner_stub')
    require Rails.root.join('test/support/repository_manager_stub')
    require Rails.root.join('test/support/webhook_creator_stub')

    register :webhook_creator, -> { WebhookCreatorStub }
    register :bash_runner, -> { BashRunnerStub }
    register :github_client, -> { GithubClientStub }
    register :repository_manager, -> { RepositoryManagerStub }
  else
    register :webhook_creator, -> { WebhookCreator }
    register :bash_runner, -> { BashRunner }
    register :github_client, -> { Octokit::Client }
    register :repository_manager, -> { RepositoryManager }
  end
end
