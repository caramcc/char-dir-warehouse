module Hero
  class ItemLibraryController < ApplicationController


    def show
      @items = ItemLibrary.all
    end

    def new
      @data = {
          :item_types => %w(Item Weapon Armor Medicinal Container),
          :weapon_types => %w(Sword Knife Spear Bow Whip Blunt Projectile Thrown-Knife Thrown-Axe Axe Flail Glaive),
          :armor_areas => %w(Head Legs Hands Torso Feet)
      }
    end

    def create
      puts params
    end


  end
end
