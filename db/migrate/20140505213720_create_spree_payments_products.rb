class CreateSpreePaymentsProducts < ActiveRecord::Migration
  def change
    create_table :spree_payments_products do |t|
      t.references :payment, index: true
      t.references :subscription_product, index: true
    end
  end
end
