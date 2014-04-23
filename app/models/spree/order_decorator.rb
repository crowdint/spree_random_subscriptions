module Spree
  Order.class_eval do
    def subscription_products
      Spree::SubscriptionProduct.joins(variants: :line_items).where('"spree_line_items"."id" IN (?)', line_items.ids)
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
