namespace :subscriptions do

  desc "Generate all subscription's orders from today"
  task generate_orders: :environment do
    Spree::Subscription.send_today.ids.each do |id|
      Spree::Subscription.delay.create_order(id)
    end
  end
end
