class CreateActionsCombatants < ActiveRecord::Migration
  def change
    create_table :actions_combatants do |t|
      t.integer :action_id
      t.integer :combatant_id
    end
  end
end
