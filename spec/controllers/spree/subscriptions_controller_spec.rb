require 'spec_helper'

describe Spree::SubscriptionsController do
  let(:user) { create(:user) }
  let(:subscription) { create(:subscription, x_subscription_id: 'AB123') }

  describe '#show' do
    before do
      controller.stub current_spree_user: user
      spree_get :show, id: subscription.id
    end

    it { expect(response).to render_template :show }
    it { expect(response.status).to eq 200 }
  end
end
