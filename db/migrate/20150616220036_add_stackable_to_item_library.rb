class AddStackableToItemLibrary < ActiveRecord::Migration
  def change
    add_column :item_libraries, :stackable, :boolean
  end
end
