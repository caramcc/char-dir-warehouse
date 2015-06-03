class AddGamesToUser < ActiveRecord::Migration
  def change
    add_column :users, :games_id, :integer
  end
end
