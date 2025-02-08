# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  # test sentry
  get 'sentry_test', to: 'application#test_sentry'

  # sidekiq
  mount Sidekiq::Web => '/sidekiq'

  # omniauth
  post 'auth/:provider', to: 'auth#request', as: :auth_request
  get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
  delete 'logout', to: 'auth#destroy', as: :logout

  resources :repositories, only: %i[index show new create] do
    resources :checks, only: [:create], module: :repository
  end

  root 'home#index'
end
