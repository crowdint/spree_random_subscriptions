require 'spec_helper'

describe Spree::RenewController do
  describe '#new' do
    let(:subscription_product) { create :subscription_product }
    let(:variant) { subscription_product.master }
    let(:user) { mock_model(Spree::User, spree_api_key: 'fake', last_incomplete_spree_order: nil) }

    before do
      controller.stub current_spree_user: user
      controller.stub current_order: create(:order)
      spree_get :edit, id: subscription_product.id
    end

    it 'adds subscription_product to current order' do
      expect(controller.current_order.contains?(variant)).to be_true
    end
  end
end
