# frozen_string_literal: true

module Web
  class RepositoriesController < ApplicationController
    before_action :authenticate_user!

    def index
      @repositories = current_user.repositories
                                  .includes(:checks)
                                  .order(created_at: :desc)
                                  .page(params[:page])
                                  .per(5)
    end

    def show
      @repository = current_user.repositories.find(params[:id])
      @checks = @repository.checks
                           .order(id: :desc)
                           .page(params[:page])
                           .per(5)
    end

    def new
      client = ApplicationContainer[:github_client].new(access_token: current_user.token, auto_paginate: true)
      @repos = client.repos
      @repository = current_user.repositories.build
    end

    def create
      @repository = current_user.repositories.find_or_initialize_by(repository_params)

      authorize @repository

      if @repository.save
        RepositoryJobs::UpdateInfoRepositoryJob.perform_later(@repository.id)
        redirect_to repositories_path, notice: t('.success')
      else
        flash[:alert] = @repository.errors.full_messages.join('\n')
        redirect_to action: :new
      end
    end

    private

    def repository_params
      params.require(:repository).permit(:github_id)
    end
  end
end
