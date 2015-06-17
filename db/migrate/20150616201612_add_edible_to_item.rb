class AddEdibleToItem < ActiveRecord::Migration
  def change
    add_column :items, :edible, :boolean
    add_column :items, :drinkable, :boolean
  end
end
