require 'sidekiq/web'

Spree::Core::Engine.routes.draw do
  authenticate :spree_user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :silent_post, only: [:create]

  resources :renew, only: :edit

  namespace :admin do
    resources :subscriptions
  end

  resources :subscription_products
end

