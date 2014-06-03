class AddGiftfieldToSpreeSubscriptions < ActiveRecord::Migration
  def change
    add_column :spree_subscriptions, :gift_name, :string
    add_column :spree_subscriptions, :gift_message, :text
    add_column :spree_subscriptions, :gift_email, :string
    add_column :spree_subscriptions, :gift, :boolean
  end
end
