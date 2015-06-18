class AddFlamingToItem < ActiveRecord::Migration
  def change
    add_column :items, :flaming, :boolean
  end
end
