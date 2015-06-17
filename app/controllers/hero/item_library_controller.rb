module Hero
  class ItemLibraryController < ApplicationController


    def show
      items = ItemLibrary.all

      @items = {}

      items.each do |item|
        if @items[item.kind].nil?
          @items[item.kind] = [item]
        else
          @items[item.kind].push item
        end
      end

    end

    def new
      @data = {
          :item_types => %w(Item Weapon Armor Medicinal Container),
          :weapon_types => ['Sword', 'Knife', 'Spear', 'Bow', 'Whip', 'Blunt', 'Projectile', 'Throwing Knife',
                            'Throwing Axe', 'Axe', 'Flail', 'Glaive'],
          :armor_areas => %w(Head Legs Hands Torso Feet)
      }
    end

    def create
      case params[:item_type]
        when 'Weapon'
          id = ItemLibrary.new_weapon(params[:item_name], params[:weapon_class], params[:description], params[:edible],
                                 params[:drinkable], params[:stackable], params[:fire_starter], params[:consumable])
        when 'Armor'
          id = ItemLibrary.new_armor(params[:item_name], params[:armor_area], params[:armor_damage], params[:description],
                                     params[:edible], params[:drinkable], params[:stackable], params[:flammable], params[:fire_starter], params[:consumable])
        when 'Medicinal'
          id = ItemLibrary.new_medicinal(params[:item_name], params[:amount_healed], params[:description], params[:edible],
                                         params[:drinkable], params[:stackable], params[:flammable], params[:fire_starter], params[:consumable])

        when 'Container'
          id = ItemLibrary.new_container(params[:item_name], params[:description], params[:full], params[:edible],
                                         params[:drinkable], params[:stackable], params[:flammable], params[:fire_starter], params[:consumable])
        else
          id = ItemLibrary.new_item(params[:item_name], params[:description], params[:edible], params[:drinkable],
                                    params[:stackable], params[:flammable], params[:fire_starter], params[:consumable])
      end

      # TODO: Add :add_to when tributes have items n stuff
      #
      # unless params[:add_to].blank?
      #   Tribute.find_by_id(params[:add_to]).add_item_from_library(id)
      # end

      # redirect_to "/hero/items/library/#{id}"
      redirect_to '/hero/items/library'
    end

    def edit
      @data = {
          :item_types => %w(Item Weapon Armor Medicinal Container),
          :weapon_types => ['Sword', 'Knife', 'Spear', 'Bow', 'Whip', 'Blunt', 'Projectile', 'Throwing Knife',
                            'Throwing Axe', 'Axe', 'Flail', 'Glaive'],
          :armor_areas => %w(Head Legs Hands Torso Feet)
      }

      @item = ItemLibrary.find_by_id(params[:item])
    end

    def update
      item = ItemLibrary.find_by_id(params[:item])

      case params[:item_type]
        when 'Weapon'
          id = item.update_weapon(params[:item_name], params[:weapon_class], params[:description], params[:edible],
                                      params[:drinkable], params[:stackable], params[:fire_starter], params[:consumable])
        when 'Armor'
          id = item.update_armor(params[:item_name], params[:armor_area], params[:armor_damage], params[:description],
                                     params[:edible], params[:drinkable], params[:stackable], params[:flammable], params[:fire_starter], params[:consumable])
        when 'Medicinal'
          id = item.update_medicinal(params[:item_name], params[:amount_healed], params[:description], params[:edible],
                                         params[:drinkable], params[:stackable], params[:flammable], params[:fire_starter], params[:consumable])

        when 'Container'
          id = item.update_container(params[:item_name], params[:description], params[:full], params[:edible],
                                         params[:drinkable], params[:stackable], params[:flammable], params[:fire_starter], params[:consumable])
        else
          id = item.update_item(params[:item_name], params[:description], params[:edible], params[:drinkable],
                                    params[:stackable], params[:flammable], params[:fire_starter], params[:consumable])
      end

      # redirect_to "/hero/items/library/#{id}"
      redirect_to '/hero/items/library'
    end


  end
end
