module Spree
  class Subscription < ActiveRecord::Base
    belongs_to :user
    belongs_to :address
    belongs_to :subscription_product
    has_many   :shipped_products, through: :orders, source: :products
    belongs_to :original_order, class_name: 'Spree::Order'
    belongs_to :payment
    belongs_to :credit_card

    has_and_belongs_to_many :orders

    after_create :create_order

    scope :send_today, -> { where next_date: Time.zone.today }
    scope :active, -> { where state: 'active' }

    state_machine initial: :active do
      event :cancel do
        transition active: :cancelled
      end

      event :activate do
        transition cancelled: :active
      end
    end

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

      orders << order
      add_line_item(order)
      set_next_order_date
      save_credit_card unless credit_card
      renew_notify

      order.next

      order
    end

    def self.create_order(subscription_id)
      find(subscription_id).create_order
    end

    def random_product
      @random_product ||= Product.unsubscribable.
        active.
        where.not('spree_products.id' => shipped_products.map(&:id)).
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

    def renew_notify
      if missing_items <= 1
        Spree::RenewMailer.send_reminder(self).deliver
      end
    end

    def add_line_item(order)
      Spree::LineItem.create(
        order: order,
        #NOTE it only works with products without variants
        variant: random_product.master
      )
    end

    def save_credit_card
      update_attribute :credit_card, payment.source
    end
  end
end
