class AddLineItemIdToSpreeAddress < ActiveRecord::Migration
  def change
    add_column :spree_addresses, :line_item_id, :integer, index: true
  end
end
