# frozen_string_literal: true

if Rails.env.production? && ENV['SENTRY_DSN'].present?
  Sentry.init do |config|
    config.dsn = ENV.fetch('SENTRY_DSN', nil)
    config.breadcrumbs_logger = %i[active_support_logger http_logger]
    config.enable_tracing = true
    config.traces_sample_rate = 0.5
  end
end
