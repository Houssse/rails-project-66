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
      authorize @repository
      @checks = @repository.checks
                           .order(created_at: :desc)
                           .page(params[:page])
                           .per(5)
    end

    def new
      client = ApplicationContainer[:github_client].new(access_token: current_user.token, auto_paginate: true)
      @repos = client.repos
      @repository = ::Repository.new
      authorize @repository
    end

    def create
      if params[:repository][:github_id].blank?
        redirect_to new_repository_path
        return
      end

      client = ApplicationContainer[:github_client].new(access_token: current_user.token)
      github_repo = client.repo(params[:repository][:github_id].to_i)
      repository = current_user.repositories.new(
        name: github_repo[:name],
        github_id: github_repo[:id],
        full_name: github_repo[:full_name],
        language: github_repo[:language].to_s.downcase,
        clone_url: github_repo[:clone_url],
        ssh_url: github_repo[:ssh_url]
      )

      authorize repository

      if repository.save
        RepositoryJobs::CreateWebhookJob.perform_later(repository.id, current_user.id)
        redirect_to repositories_path
      else
        redirect_to new_repository_path
      end
    end
  end
end
