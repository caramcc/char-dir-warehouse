class AddFlammableToItemLibrary < ActiveRecord::Migration
  def change
    add_column :item_libraries, :flammable, :boolean
    add_column :item_libraries, :firestarter, :boolean
  end
end
