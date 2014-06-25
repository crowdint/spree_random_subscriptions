module Spree
  Order.class_eval do
    has_many :subscription

    def subscription_products
      products.subscribable
    end

    def check_subscriptions!
      line_items.map do |li|
        if li.product.subscription?
          sp = li.product
          subscription = find_subscription(user, sp)

          if subscription && !subscription.recurring
            subscription.update(limit: subscription.limit += sp.limit)
          else
            Subscription.create(
              user: user,
              subscription_product: sp,
              address: li.ship_address,
              limit: sp.limit,
              credit_card:  payment.source,
              recurring: sp.recurring,
              payment_method: payment.payment_method,
              gift: li.gift,
              gift_name: li.gift_name,
              gift_email: li.gift_email
            )
          end
        end
      end
    end

    def payment
      payments.completed.last
    end

    def self.check_subscriptions!(order_id)
      Spree::Order.find(order_id).check_subscriptions!
    end

    private

    def find_subscription(user, product)
      Subscription.find_by(user: user, subscription_product: product)
    end
  end
end
