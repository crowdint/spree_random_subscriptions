require 'sidekiq/web'

Spree::Core::Engine.routes.draw do
  authenticate :spree_user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
