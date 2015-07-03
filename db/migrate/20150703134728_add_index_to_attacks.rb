class AddIndexToAttacks < ActiveRecord::Migration
  def change
    add_index :attacks, :attack_code
  end
end
