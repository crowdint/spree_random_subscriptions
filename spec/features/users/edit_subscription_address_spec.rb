require 'spec_helper'
include Warden::Test::Helpers

feature 'User can update subscription address' do
  let(:user) { create(:user) }
  let(:subscription) { create(:subscription, x_subscription_id: 'AB123', user: user) }
  let(:address) { subscription.address }

  scenario 'updating address' do
    login_as subscription.user
    visit '/account'
    click_link subscription.subscription_product.name
    click_link 'Edit Shipping Address'
    fill_in 'First Name', with: 'Julio Cesar'
    fill_in 'Last Name', with: 'Elizondo Rodriguez'
    click_button 'Update Address'
    address.reload
    expect(page).to have_content 'Address updated successfully'
    expect(address.firstname).to eq 'Julio Cesar'
    expect(address.lastname).to eq 'Elizondo Rodriguez'
  end
end
