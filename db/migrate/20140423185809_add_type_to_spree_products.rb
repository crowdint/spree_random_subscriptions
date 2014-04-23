class AddTypeToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :type, :string
    add_column :spree_products, :limit, :integer, default: 12
  end
end
