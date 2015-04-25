class CreateInventoryDelta < ActiveRecord::Migration
  def change
    create_table :inventory_delta do |t|
      t.integer :action_id
      t.integer :item_id
      t.integer :combatant_id
      t.string :change
    end
  end
end
