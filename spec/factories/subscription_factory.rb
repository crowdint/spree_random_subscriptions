FactoryGirl.define do
  factory :subscription, class: Spree::Subscription do before(:create) do
      create(:product) if Spree::Product.unsubscribable.count == 0
    end

    user { create :user }
    address { create :address }
    subscription_product { create :subscription_product }
    payment_method { create :credit_card_payment_method }
    credit_card { create :credit_card }
    limit 12
  end
end
