require 'spec_helper'

describe Spree::Subscription do
  let(:subject){ create :subscription }

  describe '#set_next_order_date' do
    it { expect(subject.next_date).to eq Time.zone.today + 1 }
  end

  describe '#missing_items' do
    context 'with default values' do
      it 'returns 12 missing_items' do
        expect(subject.missing_items).to eq 12
      end
    end

    context 'with already shipped_products' do
      before do
        subject.shipped_products << create(:product)
      end

      it 'returns 12 missing_items' do
        expect(subject.missing_items).to eq 11
      end
    end
  end

  describe '#random_product' do
    context 'with shipped_products empty' do
      let!(:product){ create :product }

      it 'returns the not subscription product' do
        expect(subject.random_product).to eq product
      end
    end

    context 'with some shipped_products' do
      let!(:product){ create :product }

      before do
        subject.shipped_products << create(:product)
        subject.shipped_products << create(:product)
      end

      it 'returns the not subscription product' do
        expect(subject.random_product).to eq product
      end
    end
  end

  describe '#create_order' do
    let!(:product){ create :product }
    let(:order){ subject.create_order }

    it 'creates a valid order' do
      expect(order).to be_valid
    end

    it 'creates a completed order' do
      expect(order.state).to eq 'complete'
    end
  end
end
