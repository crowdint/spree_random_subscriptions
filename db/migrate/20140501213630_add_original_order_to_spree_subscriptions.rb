class AddOriginalOrderToSpreeSubscriptions < ActiveRecord::Migration
  def change
    add_column :spree_subscriptions, :original_order_id, :integer
  end
end
