module Hero
  class Gamemaker < User
    belongs_to :games
    has_many :combatants

  end
end