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
      gender: ['men', 'women'],
      recurring: [true, false],
      limit: [3,6,9,12],
      wrap: ['every month', 'first month', 'none']
    }

    data[:gender].each do |gender|
      data[:wrap].each do |wrap|
        data[:recurring].each do |recurring|
          if recurring
            Spree::SubscriptionProduct.generate(gender, recurring, wrap)
          else
            data[:limit].each do |limit|
              Spree::SubscriptionProduct.generate(gender, recurring, wrap, limit)
            end
          end
        end
      end
    end
  end
end
