class DropTableAttacks < ActiveRecord::Migration
  def change
    drop_table :attacks
  end
end
