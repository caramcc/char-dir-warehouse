module Hero
  class Combatant < ActiveRecord::Base
    has_many :stations
    has_many :items
    has_and_belongs_to_many :locations
    has_and_belongs_to_many :actions
    has_many :tds

    # t.string   "type",       limit: 255
    # t.string   "name",       limit: 255
    # t.integer  "damage",     limit: 4
    # t.integer  "hp",         limit: 4
    # t.boolean  "has_fire",   limit: 1
    # t.integer  "water_days", limit: 4
    # t.integer  "food_days",  limit: 4
    # t.boolean  "poisoned",   limit: 1

    def alive?
      self.damage < self.hp
    end

   def is_tribute?
     self.type == 'Tribute'
   end

   def end_of_day

   end

  end
end