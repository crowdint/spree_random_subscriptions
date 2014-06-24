require 'spec_helper'

describe Spree::Subscription do
  let!(:product) { create :product }
  let(:subject) { create :subscription }

  describe '#missing_items' do
    context 'with already shipped_products' do
      it 'returns 11 missing_items' do
        expect(subject.missing_items).to eq 11
      end
    end
  end

  describe '#random_product' do
    context 'with shipped_products empty' do
      it 'returns the not subscription product' do
        expect(subject.random_product).to eq product
      end
    end

    context 'with some shipped_products' do
      before do
        subject.orders << create(:order)
        subject.orders << create(:order)
      end

      it 'returns the not subscription product' do
        expect(subject.random_product).to eq product
      end
    end
  end

  describe '#create_order' do
    context 'with no recurring subscription' do
      let(:order) { subject.create_order }

      it 'creates a valid order' do
        expect(order).to be_valid
      end

      it 'creates a completed order' do
        expect(order.state).to eq 'complete'
      end

      it { expect(subject.next_date).to eq Time.zone.today + 1.month }
    end

    context 'with recurring order subscription' do
      let(:subject) { create :subscription, recurring: true }
      let(:order) { subject.create_order }

      it 'creates a valid order' do
        expect(order).to be_valid
      end

      it 'creates a completed order' do
        expect(order.state).to eq 'complete'
      end

      it { expect(order).to be_paid }

      it 'has a payment' do
        expect(order.payments.size).to be 1
        expect(order.payments.last).to be_completed
        expect(order.payments.last.source_type).to eq 'Spree::CreditCard'
      end
    end
  end
end
