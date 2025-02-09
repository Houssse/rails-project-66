# frozen_string_literal: true

Rails.application.routes.draw do
  # test sentry
  get 'sentry_test', to: 'application#test_sentry'

  # omniauth
  post 'auth/:provider', to: 'auth#request', as: :auth_request
  get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
  delete 'logout', to: 'auth#destroy', as: :logout

  resources :repositories, only: %i[index show new create] do
    resources :checks, only: %i[show create], module: :repository
  end

  root 'home#index'
end
