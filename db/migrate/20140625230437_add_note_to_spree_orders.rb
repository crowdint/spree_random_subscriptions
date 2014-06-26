class AddNoteToSpreeOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :note, :text
  end
end
