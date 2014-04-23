FactoryGirl.define do
  factory :subscription, class: Spree::Subscription do
    user { create :user }
    address { create :address }
    subscription_product { create :subscription_product }
    limit 12
  end
end
