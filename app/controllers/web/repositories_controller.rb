# frozen_string_literal: true

module Web
  class RepositoriesController < ApplicationController
    before_action :authenticate_user!

    def index
      @repositories = current_user.repositories
    end

    def show
      @repository = current_user.repositories.find(params[:id])
      @checks = @repository.checks
    end

    def new
      client = ApplicationContainer[:github_client].new(access_token: current_user.token, auto_paginate: true)
      @repos = client.repos
      @repository = ::Repository.new
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
      if repository.save
        RepositoryJobs::CreateWebhookJob.perform_later(repository.id, current_user.id)
        redirect_to repositories_path
      else
        redirect_to new_repository_path
      end
    end
  end
end
