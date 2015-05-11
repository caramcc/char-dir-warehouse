class AddFlagsToCharacters < ActiveRecord::Migration
  def change
    add_column :characters, :fc_flagged, :boolean
    add_column :characters, :fc_flag, :string
    add_column :characters, :char_flagged, :boolean
    add_column :characters, :char_flag, :string
    add_column :characters, :shared_fc_owner_id, :integer
    add_column :characters, :is_dead, :boolean
    add_column :characters, :is_tribute, :boolean
    add_column :characters, :games_number, :integer
  end
end
