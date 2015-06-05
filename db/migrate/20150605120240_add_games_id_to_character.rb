class AddGamesIdToCharacter < ActiveRecord::Migration
  def change
    add_column :characters, :games_id, :integer
  end
end
