class AddActiveLocationToCombatants < ActiveRecord::Migration
  def change
    add_column :combatants, :active_location, :integer
  end
end
