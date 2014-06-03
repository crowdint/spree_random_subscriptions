module Spree
  CheckoutController.class_eval do
    before_action :permit_line_items_attributes, only: :update

    private
    def permit_line_items_attributes
      line_item_attributes = {
        line_items_attributes:[
          :id,
          :gift,
          :gift_name,
          :gift_email,
          :gift_message,
          ship_address_attributes: [
            :firstname, :lastname, :address1, :address2, :city, :country_id,
            :state_id, :zipcode, :phone, :state_name, :alternative_phone, :company,
            { country: [:iso, :name, :iso3, :iso_name],
              state: [:name, :abbr] }
          ]
        ]
      }
      Spree::PermittedAttributes.checkout_attributes.push(line_item_attributes)
    end

  end
end
