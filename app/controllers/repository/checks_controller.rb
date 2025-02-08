# frozen_string_literal: true

module Repository
  class ChecksController < ApplicationController
    before_action :set_repository

    def create
      check = @repository.checks.create!(state: 'pending')
      Repository::CheckRepositoryJob.perform_later(check.id)
      redirect_to repository_path(@repository)
    end

    private

    def set_repository
      @repository = Repository::Repo.find(params[:repository_id])
    end
  end
end
