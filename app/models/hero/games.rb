module Hero
  class Games < ActiveRecord::Base
    has_many :combatants
    has_many :tributes, class_name: 'Hero::Tribute'
    has_many :items
    has_many :actions
    has_many :gamemakers, :class_name => 'User'
    # Games init

    # add gamemaker

    # add tribute

    # add item

    class << self
      def current_games_number
        Games.where(active: true).last.number
      end
    end


  end
end