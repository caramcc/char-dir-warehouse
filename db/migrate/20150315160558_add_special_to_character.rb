class AddSpecialToCharacter < ActiveRecord::Migration
  def change
    add_column :characters, :special, :string
  end
end
