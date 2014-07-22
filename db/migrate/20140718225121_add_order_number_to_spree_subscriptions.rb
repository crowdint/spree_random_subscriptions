class AddOrderNumberToSpreeSubscriptions < ActiveRecord::Migration
  def change
    add_column :spree_subscriptions, :order_number,  :string
  end
end
