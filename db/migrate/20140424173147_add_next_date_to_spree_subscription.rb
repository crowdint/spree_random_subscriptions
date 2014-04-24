class AddNextDateToSpreeSubscription < ActiveRecord::Migration
  def change
    add_column :spree_subscriptions, :next_date, :date
  end
end
