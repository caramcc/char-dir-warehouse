class CreateCombatants < ActiveRecord::Migration
  def change
    create_table :combatants do |t|
      t.string :type
      t.string :name
      t.integer :damage
      t.integer :hp
      t.boolean :has_fire
      t.integer :water_days
      t.integer :food_days
      t.boolean :poisoned
      t.timestamps null: false
    end
  end
end