module Spree
  Order.class_eval do
    # NOTE: Remove when merged https://github.com/spree/spree/pull/4615
    remove_method :products
    remove_method :variants
    has_many :products, through: :variants
    has_many :variants, through: :line_items

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
            limit: sp.limit
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
