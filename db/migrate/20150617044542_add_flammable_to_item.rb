class AddFlammableToItem < ActiveRecord::Migration
  def change
    add_column :items, :flammable, :boolean
    add_column :items, :firestarter, :boolean
  end
end
