module Hero
  class InventoryDelta < ActiveRecord::Base
    belongs_to :action
    has_one :item
    has_one :combatant

  end
end