class AddShipAddressIdToSpreeLineItems < ActiveRecord::Migration
  def change
    add_column :spree_line_items, :ship_address_id, :integer, index: true
  end
end
