class AddPaymentIdToSpreeSubscriptions < ActiveRecord::Migration
  def change
    add_column :spree_subscriptions, :payment_id, :integer
  end
end
