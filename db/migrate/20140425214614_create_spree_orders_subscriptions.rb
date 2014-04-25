class CreateSpreeOrdersSubscriptions < ActiveRecord::Migration
  def change
    create_table :spree_orders_subscriptions do |t|
      t.references :order
      t.references :subscription
    end
  end
end
