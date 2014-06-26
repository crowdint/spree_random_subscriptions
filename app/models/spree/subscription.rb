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
      order = Order.create(
        user: user,
        bill_address: user.bill_address || address,
        ship_address: address,
        email: user.email,
        state: 'confirm',
        note: note
      )

      orders << order
      add_line_item(order)
      set_next_order_date
      renew_notify

      order.next

      create_recurring_payment(order) if recurring && !first_order
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

    def create_recurring_payment(order)
      order.payments << create_new_payment(order)

      order
    end

    def create_new_payment(order)
      payment = Spree::Payment.create(
        amount: subscription_product.price,
        source: credit_card,
        payment_method: payment_method,
        order: order
      )

      payment.purchase!

      payment
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

    def add_line_item(order)
      Spree::LineItem.create(
        order: order,
        #NOTE it only works with products without variants
        variant: random_product.master,
        quantity: 1
      )
    end
  end
end
