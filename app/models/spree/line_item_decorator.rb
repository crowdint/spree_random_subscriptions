module Spree
  LineItem.class_eval do
    has_one :ship_address, class_name: 'Spree::Address'
    alias_attribute :shipping_address, :ship_address

    accepts_nested_attributes_for :ship_address

    delegate :subscription?, to: :product, prefix: true

    def build_default_ship_address
      country = Spree::Country.find(Spree::Config[:default_country_id]) rescue Spree::Country.first
      build_ship_address country: country, state_id: 32
    end
  end
end

