# frozen_string_literal: true

module Web
  module Repository
    class ChecksController < ApplicationController
      before_action :set_repository

      def show
        @check = @repository.checks.find(params[:id])
      end

      def create
        check = @repository.checks.create!(aasm_state: 'pending')

        case @repository.language
        when 'javascript'
          ::RepositoryJobs::CheckJavascriptJob.perform_later(check.id)
        when 'ruby'
          ::RepositoryJobs::CheckRubyJob.perform_later(check.id)
        end

        redirect_to repository_path(@repository)
      end

      private

      def set_repository
        @repository = ::Repository.find(params[:repository_id])
      end
    end
  end
end
