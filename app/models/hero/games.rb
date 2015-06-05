module Hero
  class Games < ActiveRecord::Base
    has_many :combatants
    has_many :tributes, class_name: 'Warehouse::Character'
    has_many :items
    has_many :actions
    has_many :gamemakers, :class_name => 'User'
    # Games init

    # current Games

    # add gamemaker

    # add tribute

    # add item


  end
end