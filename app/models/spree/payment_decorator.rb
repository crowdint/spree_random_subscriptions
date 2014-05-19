module Spree
  Payment.class_eval do
    state_machine :initial => :checkout do
      after_transition :to => :completed, :do => :create_subscriptions!
    end

    def create_subscriptions!
      order.check_subscriptions!
    end
  end
end
