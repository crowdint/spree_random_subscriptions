class AddPaymentMethodIdToSpreeSubscriptions < ActiveRecord::Migration
  def change
    add_column :spree_subscriptions, :payment_method_id, :integer
  end
end
