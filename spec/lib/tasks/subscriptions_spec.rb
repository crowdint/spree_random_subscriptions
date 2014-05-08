require 'spec_helper'
require "rake"

describe 'subscriptions', sidekiq: :fake do
  before do
    SpreeRandomSubscriptions::Engine.load_tasks
    Rake::Task.define_task(:environment)
  end

  describe ':generate_orders' do
    let(:subscription) { create :subscription }
    let(:subscription2) { create :subscription }

    before do
      subscription.update(next_date: Time.zone.today)
    end

    it do
      expect do
        Rake::Task['subscriptions:generate_orders'].invoke
      end.to change(Sidekiq::Extensions::DelayedClass.jobs, :size).by(1)
    end
  end

  describe ':generate_products' do
    it do
      expect do
        Rake::Task['subscriptions:generate_products'].invoke
      end.to change(Spree::SubscriptionProduct, :count).by(60)
    end

    context 'generate all subscription products combinations' do
      before do
        Rake::Task['subscriptions:generate_products'].invoke
      end

      it 'generates man no recurring first month wrapping product' do
        expect do 
          Spree::SubscriptionProduct.find_by(name: 'Socks for man - Pay once - Wrap first month - By 3 months')
        end.to be_true
      end

      it 'man, no recurring, each month wrapping, 6 months' do
        expect do 
          Spree::SubscriptionProduct.find_by(name: 'Socks for man - Pay once - Wrap every month - By 6 months')
        end.to be_true
      end
    end
  end
end
