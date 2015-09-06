class CreateAttacksAgain < ActiveRecord::Migration
  def change
    create_table :attacks do |t|
      t.string :text
      t.string :armor_area
      t.float :damage
      t.integer :attack_code
    end
  end
end
