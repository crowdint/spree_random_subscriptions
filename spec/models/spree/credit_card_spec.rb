require 'spec_helper'

describe Spree::CreditCard do
  describe '#save_in_authorize' do
    let(:subject){ create :credit_card }

    context 'with a valid credit card' do
      let(:id){ '12345' }

      before do
        subject.stub(:create_payment_profile) do
          {
            'customer_payment_profile_id'  => id
          }
        end

        subject.save_in_authorize
      end

      it 'updates payment profile id' do
        expect(subject.gateway_payment_profile_id).to eq id
      end
    end

    context 'with an invalid credit card' do
      before do
        subject.stub(:create_payment_profile) do
          {
            :error  => 'Invalid credit card'
          }
        end

        subject.save_in_authorize
      end

      it 'updates payment profile id' do
        expect(subject.errors).to be_include :base
      end
    end
  end
end
