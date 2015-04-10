class CreateTableCharactersReapingChecks < ActiveRecord::Migration
  def change
    create_table :characters_reaping_checks do |t|
      t.integer :character_id, :reaping_check_id
    end
  end
end
