module Hero
  class Tribute < Combatant
    # t.integer  "damage",     limit: 4
    # t.integer  "hp",         limit: 4
    # t.boolean  "fire",       limit: 1
    # t.type     "string"
    #
    # Inherited methods:
    # alive?
    # is_tribute?

    def can_attack?(combatant)
    #   same location as combatant
    end

    def district_gender
      char = Warehouse::Character.find_by_id(character_id)
      "D#{char.home_area}#{char.gender[0].upcase}"
    end

    def username
      User.find_by_id(user_id).display_name
    end

    class << self

      def new_tribute_from_character(character)
        tribute = Tribute.new

        tribute.type = 'Hero::Tribute'
        tribute.name = character.first_name + ' ' + character.last_name
        tribute.hp = 40
        tribute.damage = 0
        tribute.has_fire = false
        tribute.water_days = 3
        tribute.food_days = 5
        tribute.poisoned = false

        tribute.user_id = character.user_id
        tribute.character_id = character.id

        tribute.save
        tribute
      end

    end


  end
end