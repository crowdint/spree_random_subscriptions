require 'spec_helper'

describe Spree::User do
  let(:subscriptions) { Spree::User.reflect_on_association(:subscriptions) }

  specify { expect(subscriptions.macro).to eq(:has_many) }
end
