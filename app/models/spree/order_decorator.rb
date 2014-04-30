module Spree
  Order.class_eval do
    # NOTE: Remove when merged https://github.com/spree/spree/pull/4615
    has_many :products, through: :variants
    has_many :variants, through: :line_items

    attr_accessor :x_subscription_id

    def subscription_products
      Spree::SubscriptionProduct.joins(variants: :line_items).where('"spree_line_items"."id" IN (?)', line_items.ids)
    end

    def create_subscriptions!
      subscription_products.map do |sp|
        Subscription.create(
          user: user,
          subscription_product: sp,
          address: ship_address,
          limit: sp.limit,
          x_subscription_id: @x_subscription_id
        )
      end
    end

    def recurring?
      products.map(&:recurring).any?
    end
  end
end
