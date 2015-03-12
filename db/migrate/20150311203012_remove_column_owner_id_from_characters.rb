class RemoveColumnOwnerIdFromCharacters < ActiveRecord::Migration
  def change
    remove_column :characters, :owner_id, :string
  end
end
