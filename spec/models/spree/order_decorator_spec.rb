require "spec_helper"

describe Spree::Order do
  let(:subscription_product) { create :subscription_product}
  let(:variant) { create :variant, product: subscription_product }
  let(:line_item) { create :line_item, variant: variant }
  let(:subject) { line_item.order }

  before do
    create :product
  end

  describe '#check_subscriptions!' do
    context 'creates a subscription' do
      it do 
        expect{ subject.check_subscriptions! }.to change {
          Spree::Subscription.count
        }.by(1)
      end
    end

    context 'updated a subscription' do
      let!(:subscription) do
        create(:subscription,
               subscription_product: subscription_product,
               user: subject.user
              )
      end

      it {
        expect { subject.check_subscriptions! }.to change {
          subscription.reload
          subscription.limit 
        }.by(12) }
    end
  end
end
