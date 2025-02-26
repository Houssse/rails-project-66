# frozen_string_literal: true

module RepositoryJobs
  class UpdateInfoRepositoryJob < RepositoryJobs::ApplicationJob
    queue_as :default

    def perform(repository_id)
      repository = Repository.find(repository_id)

      client = ApplicationContainer[:github_client].new(access_token: repository.user.token)
      github_repo = client.repo(repository.github_id)

      repository.update!(
        name: github_repo[:name],
        full_name: github_repo[:full_name],
        language: github_repo[:language].to_s.downcase,
        clone_url: github_repo[:clone_url],
        ssh_url: github_repo[:ssh_url]
      )
    rescue StandardError => e
      Rails.logger.error "Failed to update repository #{repository_id}: #{e.message}"
    end
  end
end
