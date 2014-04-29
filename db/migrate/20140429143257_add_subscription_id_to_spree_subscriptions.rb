class AddSubscriptionIdToSpreeSubscriptions < ActiveRecord::Migration
  def change
    add_column :spree_subscriptions, :x_subscription_id, :string
  end
end
