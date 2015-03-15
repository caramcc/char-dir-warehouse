class CreateCharacters < ActiveRecord::Migration
  def change
    create_table :characters do |t|

      t.timestamps null: false

      t.string  :first_name
      t.string  :last_name
      t.string  :bio_thread
      t.string  :age
      t.string  :home_area
      t.string  :gender
      t.string  :fc_first
      t.string  :fc_last
      t.boolean :char_approved
      t.boolean :fc_approved
    end
  end
end
