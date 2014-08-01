require 'spec_helper'

describe Spree::AddressesController do
  routes { Spree::Core::Engine.routes }

  let(:user) { create(:user) }
  let(:subscription) { create(:subscription,
                              x_subscription_id: 'AB123', user: user) }
  let(:address) { subscription.address }

  before { controller.stub current_spree_user: user }

  describe '#edit' do
    before { spree_get :edit, subscription_id: subscription,
             id: subscription.address }

    it { expect(response).to render_template :edit }
    it { expect(response.status).to eq 200 }
  end

  describe '#update' do
    let(:new_address) { attributes_for(:address) }

    context 'valid attributes' do
      it 'redirects to account page' do
        spree_put :update, subscription_id: subscription,
          id: subscription.address, address: new_address
        expect(response).to redirect_to account_path(user)
      end
    end

    context 'invalid attributes' do
      it 'renders edit page' do
        invalid_address = attributes_for(:address, firstname: '', lastname: '')
        spree_put :update, subscription_id: subscription,
          id: subscription.address, address: invalid_address
        expect(response).to render_template :edit
      end
    end
  end
end
