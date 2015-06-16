class CreateHeroItemLibraries < ActiveRecord::Migration
  def change
    create_table :hero_item_libraries do |t|

      t.timestamps null: false
    end
  end
end
