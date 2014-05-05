module Spree
  LineItem.class_eval do
    has_one :ship_address, class_name: 'Spree::Address'
    alias_attribute :shipping_address, :ship_address

    delegate :subscription?, to: :product, prefix: true
  end
end

