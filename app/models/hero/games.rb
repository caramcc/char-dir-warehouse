module Hero
  class Games < ActiveRecord::Base
    has_many :combatants
    has_many :items
    has_many :actions

  end
end