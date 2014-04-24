class AddPaidToSpreeSubscriptions < ActiveRecord::Migration
  def change
    add_column :spree_subscriptions, :paid, :boolean
  end
end
