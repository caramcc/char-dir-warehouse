class AddUserIdToCombatants < ActiveRecord::Migration
  def change
    add_column :combatants, :user_id, :integer
    add_column :combatants, :games_id, :integer
  end
end
