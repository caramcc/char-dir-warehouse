class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.integer :combatant1_id
      t.integer :combatant2_id
      t.integer :combatant1_starting_damage
      t.integer :combatant1_ending_damage
      t.string :type
      t.integer :location_id
      t.integer :day_id
    end
  end
end
