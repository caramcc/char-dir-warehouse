class AddStackableToItem < ActiveRecord::Migration
  def change
    add_column :items, :stackable, :boolean
  end
end
