require 'custom_model_naming'

module Spree
  Product.class_eval do
    include CustomModelNaming

    self.param_key = :product
    self.route_key = :products

    scope :unsubscribable, -> { where type: nil }
    scope :subscribable, -> { where type: 'Spree::SubscriptionProduct' }
    scope :recurrent, -> { where recurring: true }
    scope :not_recurrent, -> { where recurring: false }

    def subscription?
      false
    end

    def self.subscription_product
      Spree::Product.find_by name: 'wrapping'
    end
  end
end
