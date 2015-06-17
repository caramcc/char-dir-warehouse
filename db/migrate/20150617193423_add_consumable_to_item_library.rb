class AddConsumableToItemLibrary < ActiveRecord::Migration
  def change
    remove_column :item_libraries, :uses, :integer
    add_column :item_libraries, :consumable, :boolean
  end
end
