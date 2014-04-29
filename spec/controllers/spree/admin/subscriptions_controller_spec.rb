require 'spec_helper'

describe Spree::Admin::SubscriptionsController do
  stub_authorization!

  describe 'GET index' do
    let!(:subscription) { create :subscription }

    before do
      spree_get :index
    end

    it 'finds all the subscriptions' do
      expect(assigns(:subscriptions).first).to eq(subscription)
    end
  end
end

