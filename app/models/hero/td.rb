module Hero
  class Td < ActiveRecord::Base
    belongs_to :combatant
    belongs_to :action

  end
end