module Spree
  class Subscription < ActiveRecord::Base
    belongs_to :user
    belongs_to :address
    belongs_to :subscription_product

    has_and_belongs_to_many :shipped_products, class_name: 'Spree::Product'

    def missing_items
      limit - shipped_products.count
    end
  end
end
