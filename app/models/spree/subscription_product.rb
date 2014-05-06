module Spree
  class SubscriptionProduct < Product
    has_and_belongs_to_many :payments

    def unpaid?
      payments.completed.count == 0
    end
  end
end
