class AddCharacterIdToCombatants < ActiveRecord::Migration
  def change
    add_column :combatants, :character_id, :integer
  end
end
