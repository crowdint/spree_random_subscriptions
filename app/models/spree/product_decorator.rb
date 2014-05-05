require 'custom_model_naming'

module Spree
  Product.class_eval do
    include CustomModelNaming

    self.param_key = :product
    self.route_key = :products

    scope :unsubscribable, -> { where type: nil }
    scope :subscribable, -> { where type: 'Spree::SubscriptionProduct' }
    scope :recurring, -> { where recurring: true }
  end
end
