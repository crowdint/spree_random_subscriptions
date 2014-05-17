module Spree
  Payment.class_eval do
    has_and_belongs_to_many :subscription_products

    state_machine :initial => :checkout do
      after_transition :to => :completed, :do => :create_subscriptions!
    end

    def create_subscriptions!
      subscription_products.map do |sp|
        subscription = find_subscription(order.user, sp)

        if subscription
          subscription.update(limit: subscription.limit += sp.limit)
        else
          Subscription.create(
            original_order: self,
            user: order.user,
            subscription_product: sp,
            address: ship_address,
            limit: sp.limit,
            payment: payment,
            recurring: sp.recurring
          )
        end
      end
    end

    def recurring?
      subscription_products.any? &:recurring
    end

    #Avoid invalidate all old payments
    def invalidate_old_payments; end

    private

    def find_subscription(user, product)
      Subscription.find_by(user: user, subscription_product: product)
    end
  end
end
