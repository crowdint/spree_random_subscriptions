require 'spec_helper'

feature 'As an Admin I can manage subscriptions' do
  stub_authorization!

  context 'When there are subscriptions' do
    given!(:subscription) { create :subscription }
    given!(:product) { subscription.subscription_product }

    background do
      visit spree.admin_path
      click_link 'Subscriptions'
    end

    scenario 'displays subscriptions product name' do
      expect(page).to have_content product.name
    end

    scenario 'displays subscriptions start date' do
      expect(page).to have_content I18n.l(subscription.created_at.to_date)
    end

    scenario 'displays subscriptions issues quantity' do
      expect(page).to have_content subscription.limit
    end

    scenario 'displays subscriptions state' do
      expect(page).to have_content subscription.state
    end
  end

  context 'When there aren\'t subscriptions' do
    background do
      visit spree.admin_path
      click_link 'Subscriptions'
    end

    scenario 'displays no subscription message' do
      expect(page).to have_content I18n.t(:no_subscriptions,
                                         scope: [:subscriptions, :admin])
    end
  end
end

