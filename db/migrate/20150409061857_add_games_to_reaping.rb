class AddGamesToReaping < ActiveRecord::Migration
  def change
    add_column :reaping_checks, :games, :integer
  end
end
