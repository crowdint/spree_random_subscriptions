require 'spec_helper'

describe Spree::Payment do
  describe '#create_subscriptions' do
    let(:payment) { create :payment }

    it 'calls order create subscriptions' do
      expect(payment).to receive :create_subscriptions!

      payment.complete
    end
  end

  context 'processing' do
    let(:payment) { create :payment }

    before do
      payment.subscription_products << create(:recurring_product)
    end

    describe 'process!' do
      context 'order have recurring products' do
        it 'create a recurring transaction' do
          expect(payment).to receive :recurring!

          payment.process!
        end
      end
    end

    describe 'recurring_options' do
      it {payment.recurring_options.should == recurring_options(payment)}
    end

    describe 'recurring!' do
      let(:payment_method) {payment.payment_method}
      let(:response) {double(ActiveMerchant::Billing::Response)}

      context 'success recurring payment' do
        it 'complete the payment' do
          payment_method.should_receive(:recurring).
            with(payment.money.money.cents,
                 payment.source,
                 payment.recurring_options
                ).and_return(response)

          response.should_receive(:success?).and_return(true)
          response.should_receive(:params).
            and_return('x_recurring_id' => 'AB123')

          expect(payment).to receive(:complete!)

          payment.recurring!
        end
      end

      context 'failed recurring payment' do
        it 'failure the payment' do
          payment_method.should_receive(:recurring).with(payment.money.money.cents,
            payment.source,
            payment.recurring_options
          ).and_return(response)

          response.should_receive(:success?).and_return(false)

          expect(payment).to receive(:failure)

          lambda { payment.recurring! }.should raise_error(Spree::Core::GatewayError)

        end
      end
    end
  end

end

def recurring_options(payment)
  payment.gateway_options.merge({
    duration: {
      start_date: Time.now.strftime('%Y-%m-%d'),
      occurrences: 12
    },
    interval: { unit: :months, length: 1 },
    billing_address: {
      first_name: payment.order.billing_address.try(:first_name),
      last_name: payment.order.billing_address.try(:last_name),
    }
  })
end

