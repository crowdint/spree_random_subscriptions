FactoryGirl.define do
  factory :base_subscription_product, class: Spree::SubscriptionProduct do
    sequence(:name) { |n| "Product ##{n} - #{Kernel.rand(9999)}" }
    description { generate(:random_description) }
    price 19.99
    cost_price 17.00
    sku 'ABC'
    available_on { 1.year.ago }
    deleted_at nil
    shipping_category { |r| Spree::ShippingCategory.first || r.association(:shipping_category) }

    # ensure stock item will be created for this products master
    before(:create) { create(:stock_location) if Spree::StockLocation.count == 0 }

    after(:create) do |p|
      p.variants_including_master.each { |v| v.save! }
    end

    factory :subscription_product do
      tax_category { |r| Spree::TaxCategory.first || r.association(:tax_category) }

      factory :recurring_product do
        recurring true
      end
    end
  end
end
