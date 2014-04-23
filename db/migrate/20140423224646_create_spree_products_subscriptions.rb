class CreateSpreeProductsSubscriptions < ActiveRecord::Migration
  def change
    create_table :spree_products_subscriptions do |t|
      t.references :product, index: true
      t.references :subscription, index: true
    end
  end
end
