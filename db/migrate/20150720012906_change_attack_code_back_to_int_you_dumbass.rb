class ChangeAttackCodeBackToIntYouDumbass < ActiveRecord::Migration
  def change
    remove_index :attacks, :attack_code
    remove_column :attacks, :attack_code, :float
    remove_column :attacks, :damage, :integer
    add_column :attacks, :damage, :float
    add_column :attacks, :attack_code, :integer
    add_index :attacks, :attack_code
  end
end
