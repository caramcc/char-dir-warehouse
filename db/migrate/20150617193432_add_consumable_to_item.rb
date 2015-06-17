class AddConsumableToItem < ActiveRecord::Migration
  def change
    remove_column :items, :uses, :integer
    add_column :items, :consumable, :boolean
  end
end
