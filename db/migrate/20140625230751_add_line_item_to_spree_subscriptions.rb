class AddLineItemToSpreeSubscriptions < ActiveRecord::Migration
  def change
    add_column :spree_subscriptions, :line_item_id, :integer
  end
end
