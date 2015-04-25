module Hero
  class Item < ActiveRecord::Base
    has_one :location
    belongs_to :combatant
    belongs_to :inventory_delta

  end
end