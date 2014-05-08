class AddRecurringToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :recurring, :boolean, default: false
  end
end
