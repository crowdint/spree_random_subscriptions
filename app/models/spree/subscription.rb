module Spree
  class Subscription < ActiveRecord::Base
    belongs_to :user
    belongs_to :address
    belongs_to :subscription_product
    has_and_belongs_to_many :shipped_products, class_name: 'Spree::Product'

    after_create :create_order

    scope :send_today, -> { where next_date: Time.zone.today }

    def missing_items
      limit - shipped_products.count
    end

    def create_order
      order = Order.create(
        user: user,
        bill_address: user.bill_address || address,
        ship_address: address,
        email: user.email,
        state: 'confirm'
      )

      shipped_products << random_product
      add_line_item(order)
      set_next_order_date

      order.next

      order
    end

    def self.create_order(subscription_id)
      Spree::Subscription.find(subscription_id).create_order
    end

    def random_product
      @random_product ||= Product.unsubscribable.
        active.
        where.not(id: shipped_products).
        order("RANDOM()").
        limit(1).
        first
    end

    private

    def set_next_order_date
      if paid && missing_items > 0
        update_attribute :next_date , created_at + shipped_products.count.months
      end
    end

    def add_line_item(order)
      Spree::LineItem.create(
        order: order,
        #NOTE it only works with products without variants
        variant: random_product.master
      )
    end
  end
end
