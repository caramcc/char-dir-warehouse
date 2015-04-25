class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :number
    end
  end
end
