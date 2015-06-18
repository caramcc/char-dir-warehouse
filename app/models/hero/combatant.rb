module Hero
  class Combatant < ActiveRecord::Base
    has_many :stations
    has_many :items
    has_many :locations
    has_and_belongs_to_many :actions
    has_many :tds
    belongs_to :inventory_delta
    belongs_to :games
    belongs_to :user
    scope :tribute, -> { where(type: 'Hero::Tribute') }
    delegate :tributes, to: :tributes

    # t.string   "type",       limit: 255
    # t.string   "name",       limit: 255
    # t.integer  "damage",     limit: 4
    # t.integer  "hp",         limit: 4
    # t.boolean  "has_fire",   limit: 1
    # t.integer  "water_days", limit: 4
    # t.integer  "food_days",  limit: 4
    # t.boolean  "poisoned",   limit: 1
    # t.integer  "active_location"

    def inventory_limit
      15
    end

    def alive?
      self.damage < self.hp
    end

    def is_tribute?
      self.type == 'Tribute'
    end

    def same_location?(combatant_or_item)
      self.active_location == combatant_or_item.active_location
    end

    def end_of_day

    end

  end
end