FactoryGirl.define do
  factory :line_item_with_address, parent: :line_item do
    after(:create) do |line_item|
      create :address, line_item_id: line_item.id
    end
  end
end
