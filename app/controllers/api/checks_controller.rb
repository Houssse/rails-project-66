# frozen_string_literal: true

module Api
  class ChecksController < ApplicationController
    skip_before_action :verify_authenticity_token

    def create
      payload = request.body.read

      data = JSON.parse(payload)
      repo_full_name = data.dig('repository', 'full_name')
      commit_id = data.dig('head_commit', 'id')

      repository = Repository.find_by(full_name: repo_full_name)
      return head :not_found unless repository

      check = repository.checks.create!(commit_id: commit_id, aasm_state: :pending)

      ::RepositoryJobs::CheckRepositoryJob.perform_later(check.id)

      head :ok
    end
  end
end
