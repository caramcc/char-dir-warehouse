class AddIndexToCharacters < ActiveRecord::Migration
  def change
    add_column :characters, :owner_id, :integer
    add_index :characters, :owner_id
  end
end
