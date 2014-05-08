module Spree
  Order.class_eval do
    has_many :subscription

    attr_accessor :x_subscription_id

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
            original_order: self,
            user: user,
            subscription_product: sp,
            address: ship_address,
            limit: sp.limit
          )
        end
      end
    end

    def recurring?
      products.recurring.count > 0
    end

    private

    def find_subscription(user, product)
      Subscription.find_by(user: user, subscription_product: product)
    end
  end
end
