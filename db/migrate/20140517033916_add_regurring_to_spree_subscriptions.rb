class AddRegurringToSpreeSubscriptions < ActiveRecord::Migration
  def change
    add_column :spree_subscriptions, :recurring, :boolean
  end
end
