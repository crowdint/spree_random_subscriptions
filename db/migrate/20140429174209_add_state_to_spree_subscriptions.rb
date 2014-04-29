class AddStateToSpreeSubscriptions < ActiveRecord::Migration
  def change
    add_column :spree_subscriptions, :state, :string, default: 'active', index: true
  end
end
