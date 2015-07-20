class ChangeAttacksAttackCode < ActiveRecord::Migration
  def change
    remove_index :attacks, :attack_code
    remove_column :attacks, :attack_code, :integer
    add_column :attacks, :attack_code, :float
    add_index :attacks, :attack_code
  end
end
