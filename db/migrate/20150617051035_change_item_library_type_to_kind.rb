class ChangeItemLibraryTypeToKind < ActiveRecord::Migration
  def change
    rename_column :item_libraries, :type, :kind
  end
end
