require 'spec_helper'

describe Spree::SubscriptionProduct do
  describe '.generate' do
    context 'man, no recurring, first month wrapping' do
      let(:subject) { described_class.generate('man', false, 'first month', 3) }

      it { expect(subject.name).to eq 'Socks for man - Pay once - Wrap first month - By 3 months' }

      it { expect(subject.description).to eq "- For man\n- Price: $11\n- Wrap first month $2\n" }

      it { expect(subject.price.to_f).to eq 35 }
    end

    context 'woman, no recurring, first month wrapping, 12 months' do
      let(:subject) { described_class.generate('woman', false, 'first month', 12) }

      it { expect(subject.name).to eq 'Socks for woman - Pay once - Wrap first month - By 12 months' }

      it { expect(subject.description).to eq "- For woman\n- Price: $11\n- Wrap first month $2\n" }

      it { expect(subject.price.to_f).to eq 134 }
    end

    context 'man, no recurring, each month wrapping, 6 months' do
      let(:subject) { described_class.generate('man', false, 'every month', 6) }

      it { expect(subject.name).to eq 'Socks for man - Pay once - Wrap every month - By 6 months' }

      it { expect(subject.description).to eq "- For man\n- Price: $11\n- Wrap every month $2 X 6 = $12\n" }

      it { expect(subject.price.to_f).to eq 78 }
    end

    context 'woman, no recurring, none wrapping' do
      let(:subject) { described_class.generate('woman', false, 'none', 9) }

      it { expect(subject.name).to eq 'Socks for woman - Pay once - By 9 months' }

      it { expect(subject.description).to eq "- For woman\n- Price: $11\n" }

      it { expect(subject.price.to_f).to eq 99 }
    end

    context 'woman, recurring, first month wrapping' do
      let(:subject) { described_class.generate('woman', true, 'first month') }

      it { expect(subject.name).to eq 'Socks for woman - Pay monthly - Wrap first month' }

      it { expect(subject.description).to eq "- For woman\n- Price: $11\n- Wrap first month $2\n" }

      it { expect(subject.price.to_f).to eq 11 }
    end

    context 'man, recurring, every month wrapping' do
      let(:subject) { described_class.generate('man', true, 'every month') }

      it { expect(subject.name).to eq 'Socks for man - Pay monthly - Wrap every month' }

      it { expect(subject.description).to eq "- For man\n- Price: $11\n- Wrap every month $2\n" }

      it { expect(subject.price.to_f).to eq 13 }
    end

    context 'man, recurring, none wrapping' do
      let(:subject) { described_class.generate('man', true, 'none') }

      it { expect(subject.name).to eq 'Socks for man - Pay monthly' }

      it { expect(subject.description).to eq "- For man\n- Price: $11\n" }

      it { expect(subject.price.to_f).to eq 11 }
    end
  end

  describe '#subscription?' do
    let(:subcription_product) { create(:subscription_product) }

    specify { expect(subcription_product.subscription?).to be_true }
  end

  describe ':find_generated' do
    context 'finds the product Socks for man - Pay monthly' do
      let!(:subscription_product) { described_class.generate('man', true, 'none') }

      it 'finds the subscripiton product' do
        expect(
          described_class.find_generated('man', true, 'none', nil)
        ).to eq subscription_product
      end
    end

    context 'man, no recurring, first month wrapping' do
      let!(:subscription_product) { described_class.generate('man', false, 'first month', 3) }

      it 'finds the subscripiton product' do
        expect(
          described_class.find_generated('man', false, 'first month', 3)
        ).to eq subscription_product
      end
    end

    context 'man, no recurring, each month wrapping, 6 months' do
      let!(:subscription_product) { described_class.generate('man', false, 'every month', 6) }

      it 'finds the subscripiton product' do
        expect(
          described_class.find_generated('man', false, 'every month', 6)
        ).to eq subscription_product
      end
    end
  end
end
