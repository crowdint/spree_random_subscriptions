class RemoveOriginalOrderidAndPaymentIdFromSpreeSubscriptions < ActiveRecord::Migration
  def change
    remove_column :spree_subscriptions, :original_order_id, :integer
    remove_column :spree_subscriptions, :payment_id, :integer
  end
end
