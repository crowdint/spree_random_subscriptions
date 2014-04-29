require 'spec_helper'

feature 'As an Admin I can cancel subscriptions' do
  stub_authorization!

  context 'When there are active subscriptions' do
    given!(:subscription) { create :subscription }

    background do
      visit spree.admin_subscriptions_path
      click_on 'Cancel'
    end

    scenario 'cancels the subscription' do
      expect(page).to have_content 'cancelled'
    end
  end
end
