Spree::Payment::Processing.class_eval do

  durably_decorate :process!,  mode: 'soft', sha: '5292f513d88d8b0aa834456dfd0f567a792992eb' do
    if order.recurring?
      recurring!
    else
      original_process!
    end
  end

  def recurring!
    response = payment_method.recurring money.money.cents,
                             source,
                             recurring_options

    handle_recurring_response(response)
  end

  def recurring_options
    @recurring_options ||= gateway_options.merge({
      duration: {
        start_date: Time.now.strftime('%Y-%m-%d'),
        occurrences: 12
      },
      interval: { unit: :months, length: 1 },
      billing_address: {
        first_name: order.billing_address.try(:first_name),
        last_name: order.billing_address.try(:last_name),
      }
    })
  end

  def cancel_recurring(recurring_id)
    payment_method.provider.cancel_recurring(recurring_id)
  end

  private

  def handle_recurring_response(response)
    record_response(response)

    if response.success?
      order.x_subscription_id = response.params['x_subscription_id']
      self.complete!
    else
      self.failure
      gateway_error(response)
    end

  end
end
