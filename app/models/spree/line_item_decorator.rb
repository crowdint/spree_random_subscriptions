module Spree
  LineItem.class_eval do
    belongs_to :ship_address, foreign_key: :ship_address_id, class_name: 'Spree::Address'
    alias_attribute :shipping_address, :ship_address

    delegate :subscription?, to: :product, prefix: true
  end
end

