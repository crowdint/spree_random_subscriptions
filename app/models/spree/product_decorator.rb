module Spree
  Product.class_eval do
    scope :unsubscribable, -> { where type: nil }
    scope :subscribable, -> { where type: 'Spree::SubscriptionProduct' }
    scope :recurrent, -> { where recurring: true }
    scope :not_recurrent, -> { where recurring: false }
  end
end
