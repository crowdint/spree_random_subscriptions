require 'spec_helper'

describe Spree::SubscriptionProduct do
  describe '.generate' do
    context 'man, no recurring, first month wrapping' do
      let(:subject) { described_class.generate('man', false, 'first month') }

      it { expect(subject.name).to eq 'Socks for man - Wrap first month' }

      it { expect(subject.description).to eq "- For man\n- Price: $11\n- Wrap first month $2\n" }

      it { expect(subject.price.to_f).to eq 13 }
    end

    context 'woman, recurring, first month wrapping, 12 months' do
      let(:subject) { described_class.generate('woman', true, 'first month', 12) }

      it { expect(subject.name).to eq 'Socks for woman - Wrap first month - By 12 months' }

      it { expect(subject.description).to eq "- For woman\n- Price: $11\n- Wrap first month $2\n" }

      it { expect(subject.price.to_f).to eq 134 }
    end

    context 'man, recurring, each month wrapping, 6 months' do
      let(:subject) { described_class.generate('man', true, 'every month', 6) }

      it { expect(subject.name).to eq 'Socks for man - Wrap every month - By 6 months' }

      it { expect(subject.description).to eq "- For man\n- Price: $11\n- Wrap every month $2 X 6 = $12\n" }

      it { expect(subject.price.to_f).to eq 78 }
    end

    context 'woman, no recurring, none wrapping' do
      let(:subject) { described_class.generate('woman', false, 'none') }

      it { expect(subject.name).to eq 'Socks for woman' }

      it { expect(subject.description).to eq "- For woman\n- Price: $11\n" }

      it { expect(subject.price.to_f).to eq 11 }
    end
  end

  describe '#subscription?' do
    let(:subcription_product) { create(:subscription_product) }

    specify { expect(subcription_product.subscription?).to be_true }
  end
end
