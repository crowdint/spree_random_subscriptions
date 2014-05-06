require 'spec_helper'

describe Spree::SubscriptionProduct do
  let(:subcription_product) { create(:subscription_product) }

  describe '#subscription?' do
    specify { expect(subcription_product.subscription?).to be_true }
  end
end

