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

    def create_subscriptions!
      subscription_products.map do |sp|
        Subscription.create(
          user: user,
          subscription_product: sp,
          address: ship_address,
          limit: sp.limit
        )
      end
    end
  end
end
