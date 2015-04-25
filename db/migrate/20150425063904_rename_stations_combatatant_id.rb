class RenameStationsCombatatantId < ActiveRecord::Migration
  def change
    rename_column :stations, :combatatant_id, :combatant_id
  end
end
