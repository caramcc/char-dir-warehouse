class AddActiveLocationToItems < ActiveRecord::Migration
  def change
    add_column :items, :active_location, :integer
  end
end
