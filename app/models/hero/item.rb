module Hero
  class Item < ActiveRecord::Base
    has_one :location
    belongs_to :combatant
    belongs_to :inventory_delta
    scope :weapon, -> { where(type: 'Hero::Weapon') }
    scope :armor, -> { where(type: 'Hero::Armor') }
    scope :medicinal, -> { where(type: 'Hero::Medicinal') }
    scope :container, -> { where(type: 'Hero::Container') }
    delegate :tributes, to: :tributes

    # t.string  "type",            limit: 255
    # t.string  "name",            limit: 255
    # t.integer "damage",          limit: 4
    # t.integer "hp",              limit: 4
    # t.integer "area",            limit: 4
    # t.boolean "full",            limit: 1
    # t.integer "damage_healed",   limit: 4
    # t.boolean "poisoned",        limit: 1
    # t.boolean "purified",        limit: 1
    # t.string  "weapon_class",    limit: 255
    # t.integer "active_location", limit: 4
    # t.boolean "edible",          limit: 1
    # t.boolean "drinkable",       limit: 1
    # t.boolean "stackable",       limit: 1
    # t.boolean "flammable",       limit: 1
    # t.boolean "firestarter",     limit: 1
    # t.boolean "consumable",      limit: 1
    # t.boolean "flaming",         limit: 1
    # t.text    "description",     limit: 65535



    def same_location?(combatant_or_item)
      self.active_location == combatant_or_item.active_location
    end

    class << self

      def make()
        # delegate to subclass or make generic item


      end

    end

  end
end