module Spree
  Order.class_eval do
    has_many :subscription

    attr_accessor :x_subscription_id

    def subscription_products
      products.subscribable
    end

    def has_subscriptions?
      subscription_products.count > 0
    end

    # This code has been completely taken from spree core except for the line marked below
    # https://github.com/spree/spree/blob/master/core/app/models/spree/order/checkout.rb#L211
    def update_from_params(params, permitted_params)
      success = false
      @updating_params = params
      run_callbacks :updating_from_params do
        attributes = @updating_params[:order] ? @updating_params[:order].permit(permitted_params) : {}

        # Set existing card after setting permitted parameters because
        # rails would slice parameters containg ruby objects, apparently
        if @updating_params[:existing_card].present?
          credit_card = CreditCard.find(@updating_params[:existing_card])
          if credit_card.user_id != self.user_id || credit_card.user_id.blank?
            raise Core::GatewayError.new Spree.t(:invalid_credit_card)
          end

          attributes[:payments_attributes].first[:source] = credit_card
          attributes[:payments_attributes].first[:payment_method_id] = credit_card.payment_method_id
          attributes[:payments_attributes].first.delete :source_attributes
        end

        # Lines added
        if state == 'payment'
          invalidate_old_payments
          attributes = split_recurring_payments(attributes) if has_subscriptions?
        end
        # end of lines added

        success = self.update_attributes(attributes)
      end
      @updating_params = nil
      success
    end

    def split_recurring_payments(attributes)
      original = attributes['payments_attributes'].first

      original['amount'] += calculate_first_month_wrap_costs - calculate_recurrings_price

      original['subscription_product_ids'] = subscription_products.not_recurrent.map &:id

      new_payments = create_recurring_payments(original)

      new_payments << original if original['amount'] > 0
      attributes['payments_attributes'] =  new_payments

      attributes
    end

    private

    def create_recurring_payments(original_payment)
      subscription_products.recurrent.select{ |p| p.unpaid?(self) }.map do |p|
        new_payment = original_payment.clone

        new_payment['amount'] = p.price
        new_payment['subscription_product_ids'] = [p.id]
        new_payment
      end
    end

    def calculate_recurrings_price
      subscription_products.
        recurrent.
        select{ |p| p.unpaid?(self) }.to_a.
        inject(0){ |sum, p| sum + p.price }
    end

    def calculate_first_month_wrap_costs
      subscription_products.
        recurrent.
        where('spree_products.name LIKE \'%first month%\'').
        select{ |p| p.unpaid?(self) }.
        size * 2
    end

    def invalidate_old_payments
      payments.with_state('checkout').each &:invalidate!
    end
  end
end
