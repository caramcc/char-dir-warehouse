module Hero
  class Attack < ActiveRecord::Base

    def weaponize
      self.attack_code / 1000
      h = self.attributes
      h['weapon'] = Rails.application.config.weapon_codes[self.attack_code / 1000]
      h
    end

  end
end