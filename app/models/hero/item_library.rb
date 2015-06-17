module Hero
  class ItemLibrary < ActiveRecord::Base

    class << self

      def new_weapon(item_name, weapon_class, description, edible = false, drinkable = false, stackable = false,
                     flammable = false, fire_starter = false)
        item = ItemLibrary.new
        item.name = item_name
        item.kind = 'Weapon'
        item.weapon_class = weapon_class
        item.description = description
        item.edible = edible
        item.drinkable = drinkable
        item.stackable = stackable
        item.flammable = flammable
        item.firestarter = fire_starter

        item.save

      end

      def new_armor(item_name, armor_area, armor_amount, description, edible = false, drinkable = false, stackable = false,
                    flammable = false, fire_starter = false)
        item = ItemLibrary.new
        item.name = item_name
        item.kind = 'Armor'
        item.area = armor_area
        item.hp = armor_amount
        item.description = description
        item.edible = edible
        item.drinkable = drinkable
        item.stackable = stackable
        item.flammable = flammable
        item.firestarter = fire_starter

        item.save

      end

      def new_container(item_name, description, full, edible = false, drinkable = false, stackable = false,
                        flammable = false, fire_starter = false)
        item = ItemLibrary.new
        item.name = item_name
        item.kind = 'Container'
        item.full = full
        item.description = description
        item.edible = edible
        item.drinkable = drinkable
        item.stackable = stackable
        item.flammable = flammable
        item.firestarter = fire_starter

        item.save

      end

      def new_medicinal(item_name, amount_healed, description, edible = false, drinkable = false, stackable = false,
                        flammable = false, fire_starter = false)
        item = ItemLibrary.new
        item.name = item_name
        item.kind = 'Medicinal'
        item.damage = amount_healed
        item.description = description
        item.edible = edible
        item.drinkable = drinkable
        item.stackable = stackable
        item.flammable = flammable
        item.firestarter = fire_starter

        item.save

      end

      def new_item(item_name, description, edible = false, drinkable = false, stackable = false,
                   flammable = false, fire_starter = false)
        item = ItemLibrary.new
        item.name = item_name
        item.kind = 'Item'
        item.description = description
        item.edible = edible
        item.drinkable = drinkable
        item.stackable = stackable
        item.flammable = flammable
        item.firestarter = fire_starter

        item.save

      end

    end

  end
end