module Hero
  class ItemController < ApplicationController

    def new_from_library
      @library = Hero::ItemLibrary.find_by_id(params[:item])
      @data = {
          :item_types => %w(Item Weapon Armor Medicinal Container),
          :weapon_types => ['Sword', 'Knife', 'Spear', 'Bow', 'Whip', 'Blunt', 'Projectile', 'Throwing Knife',
                            'Throwing Axe', 'Axe', 'Flail', 'Glaive'],
          :armor_areas => %w(Head Legs Hands Torso Feet),
          :games => params[:games]
      }
    end

    def create_from_library

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

      games = Hero::Games.find_by_number(params[:games])

      case params[:item_type]
        when 'Weapon'
        when 'Armor'
        when 'Container'
        when 'Medicinal'
        else
          item = Item.new(name: params[:item_name], type: 'Hero::Item', poisoned: params[:poisoned], purified: params[:purified],
                          edible: params[:edible], drinkable: params[:drinkable], stackable: params[:stackable],
                          flammable: params[:flammable], flaming: params[:flaming], description: params[:description])
      end

      #
      # games.items << item
      #
      # games.save
      item.save
      render json: Hero::Items.all

    end

  end
end