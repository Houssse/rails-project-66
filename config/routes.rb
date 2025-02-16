# frozen_string_literal: true

Rails.application.routes.draw do
  # test sentry
  get 'sentry_test', to: 'application#test_sentry'

  # omniauth
  post 'auth/:provider', to: 'web/auth#request', as: :auth_request
  get 'auth/:provider/callback', to: 'web/auth#callback', as: :callback_auth
  delete 'logout', to: 'web/auth#destroy', as: :logout

  scope module: :web do
    resources :repositories, only: %i[index show new create] do
      resources :checks, only: %i[show create], module: :repository
    end
  end

  namespace :api do
    resources :checks, only: [:create]
  end

  root 'web/home#index'
end
