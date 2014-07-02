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

    def self.wrapping_product
      Spree::Product.find_by name: 'wrapping'
    end

    def set_default_stock_items
      stock_items = Spree::StockLocation.all.map do |l|
        Spree::StockItem.new(
            stock_location: l,
            backorderable: true
        )
      end

      self.master.stock_items = stock_items
    end
  end
end
