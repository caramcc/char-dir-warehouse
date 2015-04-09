class AddReapingCheckToCharacters < ActiveRecord::Migration
  def change
    add_reference :characters, :reaping_check, index: true
    add_foreign_key :characters, :reaping_checks
  end
end
