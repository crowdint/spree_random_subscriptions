require 'spec_helper'

describe Spree::UsersController do
  describe 'GET show' do
    let(:subscription) { create :subscription }

    before do
      @routes = Spree::Core::Engine.routes
      controller.stub current_spree_user: subscription.user
      get :show
    end

    it 'finds user subscriptions' do
      expect(assigns(:subscriptions).first).to eq(subscription)
    end
  end
end
