# frozen_string_literal: true

module AuthenticationManagement
  extend ActiveSupport::Concern

  included do
    helper_method :current_user
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def authenticate_user!
    return if signed_in?

    redirect_to root_path, alert: I18n.t('controllers.concerns.authentication_management.error')
  end

  private

  def signed_in?
    session[:user_id].present? && current_user.present?
  end
end
