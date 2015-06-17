class AddDescriptionToItemLibrary < ActiveRecord::Migration
  def change
    add_column :item_libraries, :description, :text
  end
end
