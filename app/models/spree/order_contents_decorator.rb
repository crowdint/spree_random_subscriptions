module Spree
  OrderContents.class_eval do

    private
    def add_to_line_item(variant, quantity, currency = nil, shipment = nil)
      @item_to_add = grab_line_item_by_variant(variant)

      if @item_to_add && !@item_to_add.product_subscription?
        update_existing_line_item(quantity, shipment, currency)
      else
        add_new_line_item(variant, quantity, currency, shipment)
      end

      @item_to_add.save
      @item_to_add
    end

    def add_new_line_item(variant, quantity, currency, shipment)
      @item_to_add = order.line_items.new(quantity: quantity, variant: variant)
      @item_to_add.target_shipment = shipment
      if currency
        @item_to_add.currency = currency
        @item_to_add.price    = variant.price_in(currency).amount
      else
        @item_to_add.price    = variant.price
      end
    end

    def update_existing_line_item(quantity, shipment, currency)
      @item_to_add.target_shipment = shipment
      @item_to_add.quantity += quantity.to_i
      @item_to_add.currency = currency if currency
    end

  end
end

