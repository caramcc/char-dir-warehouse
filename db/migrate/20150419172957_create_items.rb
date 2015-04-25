class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :type
      t.string :name
      t.integer :damage
      t.integer :hp
      t.integer :area
      t.boolean :full
      t.integer :uses
      t.integer :damage_healed
      t.boolean :poisoned
      t.boolean :flammable
      t.boolean :purified
      t.string :weapon_class
    end
  end
end
