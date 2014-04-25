require 'spec_helper'
require 'spec_helper'
include Warden::Test::Helpers

feature 'User can manage his subscriptions' do
  context 'When having subscriptions' do
    given(:subscription) { create :subscription }
    given(:product) { subscription.subscription_product }

    background do
      login_as subscription.user
      visit '/account'
    end

    scenario 'displays user subscribed product name' do
      expect(page).to have_content product.name
    end

    scenario 'displays subscription start date' do
      expect(page).to have_content I18n.l(subscription.created_at.to_date)
    end

    scenario 'displays issues quantity' do
      expect(page).to have_content subscription.limit
    end
  end

  context 'When not having subscriptions' do
    given(:user) { create :user }

    background do
      login_as user
      visit '/account'
    end

    scenario 'displays no subscriptions yet message' do
      expect(page).to have_content I18n.t(:no_subscriptions_yet,
                                          scope: :random_subscriptions)
    end
  end
end

