class AddEdibleToItemLibrary < ActiveRecord::Migration
  def change
    add_column :item_libraries, :edible, :boolean
    add_column :item_libraries, :drinkable, :boolean
  end
end
