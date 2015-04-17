class CreateTesseras < ActiveRecord::Migration
  def change
    create_table :tesseras do |t|
      t.integer :number
      t.boolean :approved

      t.timestamps null: false
    end
  end
end
