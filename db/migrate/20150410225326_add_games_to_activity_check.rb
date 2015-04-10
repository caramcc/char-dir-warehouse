class AddGamesToActivityCheck < ActiveRecord::Migration
  def change
    add_column :activity_checks, :games, :integer
  end
end
