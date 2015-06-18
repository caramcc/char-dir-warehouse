module Hero
  class Item < ActiveRecord::Base
    has_one :location
    belongs_to :combatant
    belongs_to :inventory_delta

    # t.string  "kind",         limit: 255
    # t.string  "name",         limit: 255
    # t.integer "damage",       limit: 4
    # t.integer "hp",           limit: 4
    # t.string  "area",         limit: 255
    # t.boolean "full",         limit: 1
    # t.string  "weapon_class", limit: 255
    # t.text    "description",  limit: 65535
    # t.boolean "edible",       limit: 1
    # t.boolean "drinkable",    limit: 1
    # t.boolean "stackable",    limit: 1
    # t.boolean "flammable",    limit: 1
    # t.boolean "firestarter",  limit: 1
    # t.boolean "consumable",   limit: 1

    def active_location
      self.location
    end

    def same_location?(combatant_or_item)
      self.active_location == combatant_or_item.active_location
    end

  end
end