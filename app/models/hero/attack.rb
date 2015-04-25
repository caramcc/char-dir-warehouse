module Hero
  class Attack < ActiveRecord::Base
    belongs_to :action

    def weaponize
      h = self.attributes
      h['weapon'] = Rails.application.config.weapon_codes[self.attack_code / 1000]
      h
    end

    def weapon
      Rails.application.config.weapon_codes[self.attack_code / 1000]
    end

  end
end