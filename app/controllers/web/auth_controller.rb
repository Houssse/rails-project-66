# frozen_string_literal: true

module Web
  class AuthController < ApplicationController
    def callback
      auth = request.env['omniauth.auth']

      auth_params = { email: auth['info']['email'] }

      user = User.find_or_create_by! auth_params
      user.email = auth['info']['email']
      user.name = auth['info']['name']
      user.nickname = auth['info']['nickname']
      user.image_url = auth['info']['image']
      user.token = auth['credentials']['token']

      user.save!

      session[:user_id] = user.id

      redirect_to root_path
    rescue StandardError => e
      redirect_to root_path, alert: I18n.t('controllers.web.auth.alert.error')
    end

    def destroy
      session[:user_id] = nil

      redirect_to root_path
    end
  end
end
