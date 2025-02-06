# frozen_string_literal: true

require 'dry/container'

class ApplicationContainer
  extend Dry::Container::Mixin

  if Rails.env.test?
    require Rails.root.join('test/support/github_client_stub')
    register :github_client, -> { GithubClientStub }
  else
    register :github_client, -> { Octokit::Client }
  end
end
