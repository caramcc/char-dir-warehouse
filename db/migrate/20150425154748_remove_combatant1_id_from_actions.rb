class RemoveCombatant1IdFromActions < ActiveRecord::Migration
  def change
    remove_column :actions, :combatant1_id
    remove_column :actions, :combatant2_id
    rename_column :actions, :combatant1_ending_damage, :recipient_ending_damage
    rename_column :actions, :combatant1_starting_damage, :recipient_starting_damage
  end
end
