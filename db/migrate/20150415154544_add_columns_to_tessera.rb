class AddColumnsToTessera < ActiveRecord::Migration
  def change
    add_column :tesseras, :character_id, :integer
    add_column :tesseras, :reaping_check_id, :integer
  end
end
