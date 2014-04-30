module Spree
  Product.class_eval do
    scope :unsubscribable, -> { where type: nil }
    scope :subscribable, -> { where type: 'Spree::SubscriptionProduct' }
    scope :recurring, -> { where recurring: true }
  end
end
