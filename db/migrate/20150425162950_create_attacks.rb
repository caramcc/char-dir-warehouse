class CreateAttacks < ActiveRecord::Migration
  def change
    create_table :attacks do |t|
      t.integer :damage
      t.string :text
      t.string :armor_area
      t.integer :attack_code
    end
  end
end
