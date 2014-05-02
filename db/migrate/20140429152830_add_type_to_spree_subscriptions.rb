class AddTypeToSpreeSubscriptions < ActiveRecord::Migration
  def change
    add_column :spree_subscriptions, :type, :string
  end
end
