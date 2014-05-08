module Spree
  Payment.class_eval do
    has_and_belongs_to_many :subscription_products

    state_machine :initial => :checkout do
      after_transition :to => :completed, :do => :create_subscriptions!
    end

    def create_subscriptions!
      order.check_subscriptions!
    end

    def recurring?
      subscription_products.any? &:recurring
    end

    def subscription_products_ids=(ids)
      self.subscripton_products = SubscriptionProduct.find(ids)
    end

    #Avoid invalidate all old payments
    def invalidate_old_payments; end
  end
end
