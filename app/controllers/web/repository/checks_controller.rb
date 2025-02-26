# frozen_string_literal: true

module Web
  module Repository
    class ChecksController < ApplicationController
      before_action :set_repository

      def show
        @check = ::Repository::Check.includes(:repository).find(params[:id])
        authorize @check
      end

      def create
        check = @repository.checks.create!
        authorize check

        ::RepositoryJobs::CheckRepositoryJob.perform_later(check.id)

        redirect_to repository_path(@repository), notice: t('.check')
      end

      private

      def set_repository
        @repository = ::Repository.find(params[:repository_id])
      end
    end
  end
end
