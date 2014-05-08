module Spree
  module BaseHelper

    def item_shipping_address(item)
      address = tag(:br)
      address << content_tag(:b, t(:ship_to, scope: :subscriptions))
      address << content_tag(:span, " #{ item.ship_address.to_s }")
      address if item.product_subscription?
    end

  end
end
