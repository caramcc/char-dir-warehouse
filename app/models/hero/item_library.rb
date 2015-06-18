module Hero
  class ItemLibrary < ActiveRecord::Base

    def to_item
      # case self.kind
      #   when 'Weapon'
      #     Hero::Weapon.new
      #   else
      #     Hero::Item.new
      # end
    end


    def update_weapon(item_name, weapon_class, description, edible = false, drinkable = false, stackable = false,
                      flammable = false, fire_starter = false, consumable = false)
      item = self
      item.name = item_name
      item.kind = 'Weapon'
      item.weapon_class = weapon_class
      item.description = description
      item.edible = edible
      item.drinkable = drinkable
      item.stackable = stackable
      item.flammable = flammable
      item.firestarter = fire_starter
      item.consumable = consumable

      item.area = nil
      item.damage = nil
      item.hp = nil
      item.full = nil

      item.save
      item.id
    end

    def update_armor(item_name, armor_area, armor_amount, description, edible = false, drinkable = false, stackable = false,
                  flammable = false, fire_starter = false, consumable = false)
      item = self
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
      item.consumable = consumable

      item.damage = nil
      item.full = nil
      item.weapon_class = nil

      item.save
      item.id
    end

    def update_container(item_name, description, full, edible = false, drinkable = false, stackable = false,
                      flammable = false, fire_starter = false, consumable = false)
      item = self
      item.name = item_name
      item.kind = 'Container'
      item.full = full
      item.description = description
      item.edible = edible
      item.drinkable = drinkable
      item.stackable = stackable
      item.flammable = flammable
      item.firestarter = fire_starter
      item.consumable = consumable

      item.area = nil
      item.damage = nil
      item.hp = nil
      item.weapon_class = nil

      item.save
      item.id
    end

    def update_medicinal(item_name, amount_healed, description, edible = false, drinkable = false, stackable = false,
                      flammable = false, fire_starter = false, consumable = false)
      item = self
      item.name = item_name
      item.kind = 'Medicinal'
      item.damage = amount_healed
      item.description = description
      item.edible = edible
      item.drinkable = drinkable
      item.stackable = stackable
      item.flammable = flammable
      item.firestarter = fire_starter
      item.consumable = consumable

      item.area = nil
      item.hp = nil
      item.full = nil
      item.weapon_class = nil

      item.save
      item.id
    end

    def update_item(item_name, description, edible = false, drinkable = false, stackable = false,
                 flammable = false, fire_starter = false, consumable = false)
      item = ItemLibrary.new
      item.name = item_name
      item.kind = 'Item'
      item.description = description
      item.edible = edible
      item.drinkable = drinkable
      item.stackable = stackable
      item.flammable = flammable
      item.firestarter = fire_starter
      item.consumable = consumable

      item.area = nil
      item.damage = nil
      item.hp = nil
      item.full = nil
      item.weapon_class = nil

      item.save
      item.id
    end



    class << self

      def new_weapon(item_name, weapon_class, description, edible = false, drinkable = false, stackable = false,
                     flammable = false, fire_starter = false, consumable = false)
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
        item.consumable = consumable

        item.save
        item.id

      end

      def new_armor(item_name, armor_area, armor_amount, description, edible = false, drinkable = false, stackable = false,
                    flammable = false, fire_starter = false, consumable = false)
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
        item.consumable = consumable

        item.save
        item.id

      end

      def new_container(item_name, description, full, edible = false, drinkable = false, stackable = false,
                        flammable = false, fire_starter = false, consumable = false)
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
        item.consumable = consumable

        item.save
        item.id

      end

      def new_medicinal(item_name, amount_healed, description, edible = false, drinkable = false, stackable = false,
                        flammable = false, fire_starter = false, consumable = false)
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
        item.consumable = consumable


        item.save
        item.id

      end

      def new_item(item_name, description, edible = false, drinkable = false, stackable = false,
                   flammable = false, fire_starter = false, consumable = false)
        item = ItemLibrary.new
        item.name = item_name
        item.kind = 'Item'
        item.description = description
        item.edible = edible
        item.drinkable = drinkable
        item.stackable = stackable
        item.flammable = flammable
        item.firestarter = fire_starter
        item.consumable = consumable

        item.save
        item.id

      end

    end

  end
end