require 'spec_helper'

describe Spree::Subscription do
  describe '#missing_items' do
    let(:subject){ create :subscription }

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
end
