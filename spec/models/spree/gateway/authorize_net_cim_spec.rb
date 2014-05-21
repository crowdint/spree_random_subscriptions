require 'spec_helper'

describe Spree::Gateway::AuthorizeNetCim do
  let(:card) { create :credit_card }

  before do
    response = double()
    response.stub(:success?){ true }
    response.stub(:params) do
      {'customer_payment_profile_id' => '12345'}
    end

    subject.stub(:create_payment_profile){ response }
  end

  it 'returns customer_payment_profile_id' do
    data = subject.create_payment_profile_form_card(card)
    expect(data['customer_payment_profile_id']).to be_present
  end
end
