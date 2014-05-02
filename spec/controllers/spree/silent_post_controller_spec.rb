require 'spec_helper'

describe Spree::SilentPostController do
  let(:subscription) { create(:subscription, x_subscription_id: 'AB123') }

  describe '#create' do
    context 'payment was successful' do
      it 'create a new subscription' do
        Spree::Subscription.should_receive(:find_by_x_subscription_id).
          with('AB123').
          and_return(subscription)

        expect(subscription).to receive(:create_order)

        spree_post :create, x_response_code: '1', x_subscription_id: 'AB123'
      end
    end

    context 'payment was unsuccessful' do
      it 'create a new subscription' do
        expect(subscription).to_not receive(:create_order)

        spree_post :create, x_response_code: '2'
      end
    end
  end
end
