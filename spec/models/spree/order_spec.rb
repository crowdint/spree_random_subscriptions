require "spec_helper"

describe Spree::Order do
  describe '#create_subscriptions!' do
    let(:variant) { create :variant, product: create(:subscription_product) }
    let(:line_item) { create :line_item, variant: variant }
    let(:order) { line_item.order }

    it 'creates one subscription' do
      expect{ order.create_subscriptions! }.to change{ Spree::Subscription.count }.by(1)
    end
  end
end
