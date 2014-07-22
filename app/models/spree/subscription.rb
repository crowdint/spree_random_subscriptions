module Spree
  class Subscription < ActiveRecord::Base
    belongs_to :user
    belongs_to :address
    belongs_to :subscription_product
    belongs_to :credit_card
    belongs_to :payment_method
    belongs_to :line_item
    has_many   :shipped_products, through: :orders, source: :products
    has_and_belongs_to_many :orders

    after_create :create_first_order

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
      limit && limit - shipped_products.count || Float::INFINITY
    end

    def create_first_order
      create_order(true)
    end

    def create_order(first_order = false)
      order = create_new_order
      orders << order
      add_random_line_item(order)
      add_wrapping(order, first_order)
      set_next_order_date
      renew_notify

      order.next

      create_recurring_order if recurring && !first_order
      order
    end

    def self.create_order(subscription_id)
      find(subscription_id).create_order
    end

    def random_product
      Spree::Product.unsubscribable.
        active.
        where.not('spree_products.id' => shipped_products.map(&:id)).
        order("RANDOM()").
        limit(1).
        first
    end

    def note
      if gift?
        "To: #{ self.gift_name } (#{ self.gift_email })\n" + 
        "message: \"#{ self.gift_message }\""
      end
    end

    private

    def add_wrapping(order, first_order)
      return false unless first_order && subscription_product.first_month_wrapping? || subscription_product.wrap_every_month?
      add_line_item(order, Spree::Product.wrapping_product )
    end

    def create_recurring_order
      order = create_new_order
      add_line_item(order, subscription_product)
      order.update_totals

      payment = create_new_payment(order)
      order.next

      payment.purchase!
      order
    end

    def create_new_order
      Order.create(
        user: user,
        bill_address: user.bill_address || address,
        ship_address: address,
        email: user.email,
        state: 'confirm',
        note: note,
        number: order_number
      )
    end

    def create_new_payment(order)
      Spree::Payment.create(
        amount: order.total,
        source: credit_card,
        payment_method: payment_method,
        order: order
      )
    end

    def set_next_order_date
      if missing_items > 0
        update_attribute :next_date , created_at + shipped_products.count.months
      end
    end

    def renew_notify
      if missing_items <= 1
        Spree::RenewMailer.send_reminder(self).deliver
      end
    end

    def add_random_line_item(order)
      add_line_item(order, random_product)
    end

    def add_line_item(order, product, quantity = 1)
      Spree::LineItem.create(
        order: order,
        variant: product.master,
        quantity: 1
      )
    end
  end
end
