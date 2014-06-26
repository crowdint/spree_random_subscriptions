module Spree
  class SubscriptionProduct < Product
    attr_accessor :wrap_cost
    attr_accessor :wrap_type

    def subscription?
      true
    end

    def first_month_wrapping?
      name =~ /first month/
    end
  end
end
