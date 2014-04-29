require 'sidekiq/web'

Spree::Core::Engine.routes.draw do
  authenticate :spree_user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  get '/renew/:id', to: 'renew#edit'
end
