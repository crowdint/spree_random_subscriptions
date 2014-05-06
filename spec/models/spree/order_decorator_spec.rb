require 'spec_helper'

describe Spree::Order do
  let(:subscription_product) { create :subscription_product }
  let(:variant) { create :variant, product: subscription_product }
  let(:line_item) { create :line_item, variant: variant }
  let(:subject) { line_item.order }

  before do
    create :product

    subject.update_totals
  end

  describe '#check_subscriptions!' do
    context 'creates a subscription' do
      it 'adds a subscription' do
        expect { subject.check_subscriptions! }.to change {
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

      it 'updates subscription limit' do
        expect { subject.check_subscriptions! }.to change {
          subscription.reload
          subscription.limit
        }.by(12)
      end
    end
  end

  describe '#split_recurring_payments' do
    let(:recurring_product) { create :recurring_product }

    let(:attributes) do
      {"coupon_code"=>"",
       "payments_attributes"=> [{
          "amount"=> subject.total,
          "payment_method_id"=>"6",
            "source_attributes"=>
          {"number"=>"4007 0000 0000 0027",
           "expiry"=>"12 / 19",
           "verification_value"=>"857",
           "cc_type"=>"visa",
           "name"=>"Steven Barragan"}
        }]
      }
    end

    context 'without recurring product' do
      it 'stays the same' do
        result = subject.split_recurring_payments(attributes)

        expect(result['payments_attributes'].first['subscription_product_ids']).
          to eq [subscription_product.id]
      end
    end

    context 'with recurring product' do
      before do
        subject.contents.add(recurring_product.master)
      end

      it 'creates a new payment method' do
        result = subject.split_recurring_payments(attributes)

        expect(result['payments_attributes'].first['subscription_product_ids']).
          to eq [recurring_product.id]
      end
    end
  end
end
