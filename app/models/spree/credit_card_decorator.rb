module Spree
  CreditCard.class_eval do
    def save_in_authorize
      info = create_payment_profile
      if info['customer_payment_profile_id']
        self.gateway_payment_profile_id = info['customer_payment_profile_id']
        self.payment_method = payment_method
        self.save
      else
        errors.add :base, info[:error]
        false
      end
    end

    private

    def create_payment_profile
      payment_method.create_payment_profile_form_card(self)
    end

    def payment_method
      @payment_method ||= Spree::PaymentMethod.find_by type: 'Spree::Gateway::AuthorizeNetCim'
    end
  end
end
