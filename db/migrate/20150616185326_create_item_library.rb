class CreateItemLibrary < ActiveRecord::Migration
  def change
    create_table :item_libraries do |t|
      t.string :type
      t.string :name
      t.integer :damage
      t.integer :hp
      t.string :area
      t.boolean :full
      t.integer :uses
      t.string :weapon_class
    end
  end
end
