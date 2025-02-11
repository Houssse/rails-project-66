# frozen_string_literal: true

module Repository
  class Repo < ApplicationRecord
    self.table_name = 'repositories'
    after_create :setup_webhook

    extend Enumerize

    belongs_to :user
    has_many :checks, class_name: 'Repository::Check', foreign_key: 'repository_id', dependent: :destroy,
                      inverse_of: :repository

    enumerize :language, in: %w[ruby javascript], predicates: true

    validates :name, :github_id, :full_name, :language, :clone_url, :ssh_url, presence: true
    validates :github_id, uniqueness: true
    
    private

    def setup_webhook
      return unless user.token.present?
  
      client = Octokit::Client.new(access_token: user.token)
  
      webhook_url = Rails.application.routes.url_helpers.api_checks_url(host: ENV['BASE_URL'])
  
      client.create_hook(
        full_name,
        'web',
        {
          url: webhook_url,
          content_type: 'json',
          secret: ENV['GITHUB_WEBHOOK_SECRET']
        },
        {
          events: ['push'],
          active: true
        }
      )
    rescue Octokit::UnprocessableEntity
      Rails.logger.warn "Webhook already exists for #{full_name}"
    end
  end
end
