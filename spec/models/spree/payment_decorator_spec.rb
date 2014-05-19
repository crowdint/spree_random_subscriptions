require 'spec_helper'

describe Spree::Payment do
  describe '#create_subscriptions' do
    let(:payment) { create :payment }

    it 'calls order create subscriptions' do
      expect(payment).to receive :create_subscriptions!

      payment.complete
    end
  end
end
