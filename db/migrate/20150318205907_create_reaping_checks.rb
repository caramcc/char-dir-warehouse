class CreateReapingChecks < ActiveRecord::Migration
  def change
    create_table :reaping_checks do |t|
      t.timestamp :opens_on
      t.timestamp :closes_on

      t.timestamps null: false
    end
  end
end
