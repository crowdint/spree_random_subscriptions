require 'spec_helper'

describe Spree::Payment do
  describe '#create_subscriptions' do
    let(:payment) { create :payment }

    it 'calls order create subscriptions' do
      expect(payment).to receive :create_subscriptions!

      payment.complete
    end

    it 'adds a delayed job' do
      expect do
        payment.complete
      end.to change(Sidekiq::Extensions::DelayedClass.jobs, :size).by(1)
    end
  end
end
