module Hero
  class Station < ActiveRecord::Base
    belongs_to :combatant

  end
end