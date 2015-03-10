class RemoveColumnFromCharacter < ActiveRecord::Migration
  def change
    remove_column :characters, :age, :string
  end
end
