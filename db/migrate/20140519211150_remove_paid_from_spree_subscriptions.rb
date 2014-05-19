class RemovePaidFromSpreeSubscriptions < ActiveRecord::Migration
  def change
    remove_column :spree_subscriptions, :paid, :boolean
  end
end
