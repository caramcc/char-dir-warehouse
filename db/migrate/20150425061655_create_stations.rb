class CreateStations < ActiveRecord::Migration
  def change
    create_table :stations do |t|
      t.boolean :combat
      t.string :station_name
      t.integer :combatatant_id
    end
  end
end
