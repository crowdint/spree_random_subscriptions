require 'spec_helper'

describe Spree::Product do
  let(:product) { create(:product) }

  describe '#subscription?' do
    specify { expect(product.subscription?).to be_false }
  end
end

