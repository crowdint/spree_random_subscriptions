class AddCreditCardIdToSpreeSubscriptons < ActiveRecord::Migration
  def change
    add_reference :spree_subscriptions, :credit_card, index: true
  end
end
