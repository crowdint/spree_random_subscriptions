require 'spec_helper'

describe Spree::Subscription do
  let(:subject){ create :subscription }

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
end
