FactoryGirl.define do
  factory :order_with_subscription_products, class: Spree::Order do
    sequence(:number) { |n| n }
    state 'cart'
  end
end
