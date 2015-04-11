class CreateActivityChecks < ActiveRecord::Migration
  def change
    create_table :activity_checks do |t|
      t.timestamp :opens_on
      t.timestamp :closes_on

      t.timestamps null: false
    end
  end
end
