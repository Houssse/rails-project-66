# frozen_string_literal: true

class WebhookCreator
  def initialize(repository, user)
    @repository = repository
    @user = user
  end

  def call
    return if @user.token.blank?

    client = Octokit::Client.new(access_token: @user.token)

    base_url = ENV.fetch('BASE_URL') do
      Rails.logger.error 'BASE_URL is not set. Webhook not created.'
      return
    end

    webhook_url = Rails.application.routes.url_helpers.api_checks_url(host: base_url)

    client.create_hook(
      @repository.full_name,
      'web',
      {
        url: webhook_url,
        content_type: 'json'
      },
      {
        events: ['push'],
        active: true
      }
    )
  rescue Octokit::UnprocessableEntity => e
    Rails.logger.warn "Webhook already exists for #{@repository.full_name}: #{e.message}"
  rescue Octokit::Error => e
    Rails.logger.error "Failed to create webhook for #{@repository.full_name}: #{e.message}"
  end
end
