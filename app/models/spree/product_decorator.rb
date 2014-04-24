module Spree
  Product.class_eval do
    scope :unsubscribable, -> { where type: nil }
  end
end
