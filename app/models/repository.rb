# frozen_string_literal: true

class Repository < ApplicationRecord
  extend Enumerize
  
  after_create :setup_webhook

  belongs_to :user
  has_many :checks , foreign_key: 'repository_id', dependent: :destroy,
                    inverse_of: :repository

  enumerize :language, in: %w[ruby javascript], predicates: true

  validates :name, :github_id, :full_name, :language, :clone_url, :ssh_url, presence: true
  validates :github_id, uniqueness: true

  private

  def setup_webhook
    return if user.token.blank?

    client = Octokit::Client.new(access_token: user.token)

    webhook_url = Rails.application.routes.url_helpers.api_checks_url(host: ENV.fetch('BASE_URL', nil))

    client.create_hook(
      full_name,
      'web',
      {
        url: webhook_url,
        content_type: 'json',
        secret: ENV.fetch('GITHUB_WEBHOOK_SECRET', nil)
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
