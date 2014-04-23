class CreateSpreeSubscriptions < ActiveRecord::Migration
  def change
    create_table :spree_subscriptions do |t|
      t.references :user, index: true
      t.references :address, index: true
      t.references :subscription_product, index: true
      t.integer    :limit

      t.timestamps
    end
  end
end
