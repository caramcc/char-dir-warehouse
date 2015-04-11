class AddActivityCheckToCharacters < ActiveRecord::Migration
  def change
    add_reference :characters, :activity_check, index: true
    add_foreign_key :characters, :activity_checks
  end
end
