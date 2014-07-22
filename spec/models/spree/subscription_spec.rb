require 'spec_helper'

describe Spree::Subscription do
  let!(:product) { create :product }

  let(:subject) { create :subscription }

  describe '#missing_items' do
    context 'with already shipped_products' do
      it 'returns 11 missing_items' do
        expect(subject.missing_items).to eq 11
      end
    end
  end

  describe '#random_product' do
    context 'with shipped_products empty' do
      it 'returns the not subscription product' do
        expect(subject.random_product).to eq product
      end
    end

    context 'with some shipped_products' do
      before do
        subject.orders << create(:order)
        subject.orders << create(:order)
      end

      it 'returns the not subscription product' do
        expect(subject.random_product).to eq product
      end
    end
  end

  describe '#create_order' do
    context 'with no recurring subscription' do
      let(:order) { subject.create_order }

      it 'creates a valid order' do
        expect(order).to be_valid
      end

      it 'creates a completed order' do
        expect(order.state).to eq 'complete'
      end

      it { expect(subject.next_date).to eq Time.zone.today + 1.month }
    end

    context 'with recurring order subscription' do
      let!(:subject) { create :subscription, recurring: true }
      let!(:order) { subject.create_order }
      let(:second_order) { Spree::Order.last }

      it 'creates a valid order' do
        expect(order).to be_valid
      end

      it 'creates two completed order' do
        expect(order.state).to eq 'complete'
        expect(second_order.state).to eq 'complete'
      end

      it 'creates a second order with a payment' do
        expect(second_order).not_to eq order
        expect(second_order).to be_paid
        expect(second_order.payments.last).to be_completed
        expect(second_order.payments.last.source_type).to eq 'Spree::CreditCard'
      end
    end

    context 'with a gift' do
      let(:subject) do
        create :subscription,
          gift:         true,
          gift_name:    'test name',
          gift_message: 'test message',
          gift_email: 'test@test.com'
      end
      let(:order) { subject.orders.first }

      it {expect(order.note).not_to be_blank }
    end

    context 'wrapping' do
      let!(:wrapping) { create :product, name: 'wrapping' }

      context 'first month' do
        let(:subscription) do
          create :subscription,
            subscription_product: create(:subscription_product, name: 'Wrapping first month')
        end
        let(:order) { subscription.orders.last }

        it { expect(order.products).to include wrapping }
      end

      context 'every month' do
        let(:subscription) do
          create :subscription,
            subscription_product: create(:subscription_product, name: 'Wrapping every month')
        end
        let(:order) { subscription.orders.first }
        let(:second_order) { subscription.create_order }

        it { expect(order.products).to include wrapping }
        it { expect(second_order.products).to include wrapping }
      end
    end
  end

  describe '#note' do
    context 'with a gift subscription' do
      let(:subject) do
        create :subscription,
          gift:         true,
          gift_name:    name,
          gift_message: message,
          gift_email: email
      end
      let(:name) { 'Test name' }
      let(:message) { 'Test Message' }
      let(:email) { 'test@test.com' }

      it { expect(subject.note).to include name }
      it { expect(subject.note).to include message }
      it { expect(subject.note).to include email }
    end
  end

  describe 'number' do
    let(:order) { create :order }
    let(:subscription) do
      create :subscription,
             order_number: order.number
    end

    let(:first_order) { subscription.orders.first }
    let(:second_order) { subscription.create_order }

    context 'when creates a new subscription' do
      it 'creates an order with a consistent order number' do
        expect( first_order.number ).to eq "#{order.number}-1"
      end
    end

    context 'when adds a second order to a subscription' do
      it 'creates an order with a sequential order number' do
        expect( second_order.number ).to eq "#{order.number}-2"
      end
    end
  end
end
