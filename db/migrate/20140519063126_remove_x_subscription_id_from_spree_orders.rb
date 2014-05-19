class RemoveXSubscriptionIdFromSpreeOrders < ActiveRecord::Migration
  def change
    remove_column :spree_orders, :x_subscription_id, :integer
  end
end
