class AddPreviousNumberToTessera < ActiveRecord::Migration
  def change
    add_column :tesseras, :previous_number, :integer
  end
end
