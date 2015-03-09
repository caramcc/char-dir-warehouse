class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|

      t.timestamps null: false
      t.integer :user_id
      t.string :username
      t.string :display_name
      t.string :password
      t.string :characters
      t.string :group
    end
  end
end
