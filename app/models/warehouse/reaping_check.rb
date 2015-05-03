module Warehouse
  class ReapingCheck < ActiveRecord::Base
    # t.timestamp :opens_on, t.timestamp :closes_on
    has_and_belongs_to_many :characters
    belongs_to :tessera

    def is_active?
      Time.now.to_i > self.opens_on.to_i && Time.now.to_i < self.closes_on.to_i
    end

    def can_open_new?
      all_checks = ReapingCheck.all
      all_checks.each do |check|
        if check.is_active? || (check[:opens_on].to_i > self.opens_on.to_i && check[:closes_on].to_i < self.opens_on.to_i)
          # can only have one check open at a time
          return false
        end
      end

      true
    end

    class << self
      def current_games
        ReapingCheck.all.each do |check|
          if check.is_active?
            return check.games
          end
        end

        false
      end

      def current_games_id
        ReapingCheck.all.each do |check|
          if check.is_active?
            return check.id
          end
        end

        false
      end


    end
  end
end
