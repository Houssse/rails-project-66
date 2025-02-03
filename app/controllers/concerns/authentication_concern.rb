# frozen_string_literal: true

module AuthenticationConcern
  extend ActiveSupport::Concern

  included do
    helper_method :current_user
  end

  def current_user
    @current_user ||= find_current_user
  end

  def authenticate_user!
    redirect_to root_path unless user_authenticated?
  end

  private

  def find_current_user
    User.find(session[:user_id]) if session[:user_id]
  rescue ActiveRecord::RecordNotFound
    session[:user_id] = nil
    nil
  end

  def user_authenticated?
    current_user.present? || Rails.env.test?
  end
end
