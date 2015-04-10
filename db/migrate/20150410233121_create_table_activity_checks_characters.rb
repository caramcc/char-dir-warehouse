class CreateTableActivityChecksCharacters < ActiveRecord::Migration
  def change
    create_table :activity_checks_characters do |t|
      t.integer :character_id, :activity_check_id
    end
  end
end
