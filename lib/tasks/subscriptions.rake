namespace :subscriptions do

  desc "Generate all subscription's orders from today"
  task generate_orders: :environment do
    Spree::Subscription.send_today.ids.each do |id|
      Spree::Subscription.delay.create_order(id)
    end
  end

  desc 'Generate subscription products'
  task generate_products: :environment do
    data = {
      gender: ['men', 'womem'],
      recurring: [true, false],
      limt: [3,6,9,12],
      wrap: ['every month', 'first month', 'none']
    }

    data[:gender].each do |gender|
      date[:recurring].each do |recurring|
        data[:wrap].each do |wrap|

        end
      end
    end
  end
end
