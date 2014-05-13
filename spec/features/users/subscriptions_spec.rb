require 'spec_helper'
include Warden::Test::Helpers

feature 'shipping address for subscription' do
  let!(:address) { create(:address) }
  let!(:user) { create(:user, billing_address: address) }
  let!(:shipping_category) do
    create(:shipping_category, shipping_methods: [shipping_method])
  end
  let!(:shipping_method) { create(:shipping_method) }
  let!(:subscription_product1) do
    create(:subscription_product,
           name: 'Subscription 1',
           shipping_category: shipping_category)
  end
  let!(:subscription_product2) do
    create(:subscription_product,
           name: 'Subscription 2',
           shipping_category: shipping_category)
  end
  let!(:order) { create(:order, state: 'cart', user: user) }
  let!(:line_item1) do
    create(:line_item,
           order: order,
           quantity: 1,
           product: subscription_product1)
  end
  let!(:line_item2) do
    create(:line_item,
           order: order,
           quantity: 1,
           product: subscription_product2)
  end

  background do
    login_as user
    Spree::CheckoutController.any_instance.stub(current_order: order)
    Spree::OrdersController.any_instance.stub(current_order: order)
    visit '/cart'
    click_button 'Checkout'
  end

  context 'same as billing address' do
    context 'checkout address page' do
      scenario 'subscription product 1 checked checkbox' do
        expect(page.find('#1-address-checkbox').checked?).to eq 'checked'
      end

      scenario 'subscription product 2 checked checkbox' do
        expect(page.find('#2-address-checkbox').checked?).to eq 'checked'
      end
    end

    context 'checkout delivery page', js: true do
      scenario 'checking the values for subscription shipment' do
        page.find(:css, '#order_use_billing').set(true)
        click_button 'Save and Continue'
        expect(page).to have_content('Subscription 1')
        expect(page).to have_content('Subscription 2')
        expect(page).to have_content(
          "#{ address.firstname } #{ address.lastname }: #{ address.address1 }"
        )
      end
    end

    context 'diferent as billing address' do
      context 'checkout address page' do
        scenario 'changing shipping address for one subscription' do
          page.find(:css, '#order_use_billing').set(true)
          page.find(:css, '#1-address-checkbox').set(false)
          #binding.pry
          within('#1-address') do
            fill_in 'First Name', with: 'Jose'
            fill_in 'Last Name', with: 'Cuervo'
            fill_in 'Street Address', with: 'Something there #332'
            #binding.pry
            fill_in 'City', with: 'Springfield'
            select 'United States of America', from: 'Country'
            fill_in 'State', with: 'Texas'
            select 'Alabama', from: 'State'
            fill_in 'Zip', with: '28000'
            fill_in 'Phone', with: '3121111111'
          end
          click_button 'Save and Continue'
          expect(page).to have_content(
            "#{ address.firstname } #{ address.lastname }: #{ address.address1 }"
          )
          expect(page).to have_content("Jose Cuervo: Something there #332")
        end
      end
    end
  end
end

