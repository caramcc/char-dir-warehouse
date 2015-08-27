class AddItemLibraryIdToItem < ActiveRecord::Migration
  def change
    add_column :items, :item_library_id, :integer
  end
end
