class CreateTds < ActiveRecord::Migration
  def change
    create_table :tds do |t|
      t.integer :action_id
      t.integer :combatant_id
      t.integer :td_counter
      t.boolean :active
    end
  end
end
