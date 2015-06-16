class CreateItemLibrary < ActiveRecord::Migration
  def change
    create_table :item_libraries do |t|
      t.string :name
      t.string :description
      t.string :effect_type
      t.integer :effect_amount
    end
  end
end
