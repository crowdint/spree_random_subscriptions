class AddNoteToSpreeSubscriptions < ActiveRecord::Migration
  def change
    add_column :spree_subscriptions, :note, :text
  end
end
