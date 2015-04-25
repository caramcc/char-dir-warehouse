module Hero
  class InventoryDelta < ActiveRecord::Base
    belongs_to :action

  end
end