module Hero
  class Item < ActiveRecord::Base
    has_one :location
    belongs_to :combatant
    belongs_to :inventory_delta

    def active_location
      self.location
    end

    def same_location?(combatant_or_item)
      self.active_location == combatant_or_item.active_location
    end

  end
end