# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  include AuthenticationConcern

  def test_sentry
    raise 'Проверка работы Sentry!'
  end
end
