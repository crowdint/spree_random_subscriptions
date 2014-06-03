class AddGiftfieldToSpreeLineItems < ActiveRecord::Migration
  def change
    unless column_exists? :spree_line_items, :gift
      add_column :spree_line_items, :gift_name, :string
      add_column :spree_line_items, :gift_message, :text
      add_column :spree_line_items, :gift_email, :string
      add_column :spree_line_items, :gift, :boolean
    end
  end
end
