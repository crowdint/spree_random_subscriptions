module Spree
  class RenewController < Spree::StoreController
    def edit
      product = Spree::SubscriptionProduct.find(params['id'])
      if product
        current_order.line_items << Spree::LineItem.new(
          variant: product.master
        )
        current_order.save

        redirect_to cart_path
      else
        redircet_to root_path
      end
    end
  end
end
