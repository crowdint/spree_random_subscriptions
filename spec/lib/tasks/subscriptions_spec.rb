require "spec_helper"
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
      subscription.update(next_date: Time.zone.today )
    end

    it do
      expect {
        Rake::Task['subscriptions:generate_orders'].invoke
      }.to change(Sidekiq::Extensions::DelayedClass.jobs, :size).by(1)
    end
  end
end
