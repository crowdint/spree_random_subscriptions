module Spree
  Order.class_eval do
    has_many :subscription

    def subscription_products
      products.subscribable
    end

    def check_subscriptions!
      subscription_products.map do |sp|
        subscription = find_subscription(user, sp)

        if subscription
          subscription.update(limit: subscription.limit += sp.limit)
        else
          Subscription.create(
            user: user,
            subscription_product: sp,
            address: ship_address,
            limit: sp.limit,
            credit_card:  payments.completed.last.source,
            recurring: sp.recurring
          )
        end
      end
    end

    private

    def find_subscription(user, product)
      Subscription.find_by(user: user, subscription_product: product)
    end
  end
end
