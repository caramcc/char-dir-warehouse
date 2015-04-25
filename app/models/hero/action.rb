module Hero
  class Action < ActiveRecord::Base
    has_many :inventory_deltas
    has_one :td
    has_one :recipient, class_name: 'Combatant'
    has_one :actor, class_name: 'Combatant'

  end
end