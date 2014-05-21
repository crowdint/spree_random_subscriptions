module Spree
  Gateway::AuthorizeNetCim.class_eval do
    def create_payment_profile_form_card(card)
      if card.valid?
        response = create_payment_profile(card)
        if response.success?
          response.params
        else
          {
            error: response.params['messages']['message']['text']
          }
        end
      end
    end

    private

    def create_payment_profile(card)
      options = options_for_payment_profile(card)
      cim_gateway.create_customer_payment_profile(options)
    end

    def options_for_payment_profile(card, address = nil)
      {
        customer_profile_id: card.gateway_customer_profile_id,
        payment_profile: {
          bill_to: generate_address_hash(address),
          payment: {
            credit_card: card
          }
        }
      }
    end
  end
end
