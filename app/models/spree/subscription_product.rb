module Spree
  class SubscriptionProduct < Product
    def subscription?
      true
    end
  end
end

