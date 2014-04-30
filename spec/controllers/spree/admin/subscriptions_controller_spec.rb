require 'spec_helper'

describe Spree::Admin::SubscriptionsController do
  stub_authorization!
  let!(:subscription) { create :subscription }

  describe 'GET index' do
    before do
      spree_get :index
    end

    it 'finds all the subscriptions' do
      expect(assigns(:subscriptions).first).to eq(subscription)
    end
  end

  describe 'DELETE destroy' do
    before do
      spree_delete :destroy, id: subscription.id
    end

    it 'cancels the subscription' do
      expect(subscription.reload.cancelled?).to be_true
    end
  end
end

