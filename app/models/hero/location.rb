module Hero
  class Location < ActiveRecord::Base
    has_many :items
    has_many :combatants

  end
end