class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.boolean :open
      t.integer :closed_on
    end
  end
end
