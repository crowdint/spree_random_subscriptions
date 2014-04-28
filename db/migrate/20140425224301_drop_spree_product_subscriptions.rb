class DropSpreeProductSubscriptions < ActiveRecord::Migration
  def change
    drop_table :spree_products_subscriptions
  end
end
