class SlackController < ApplicationController
  def slack_attack
    text = params.fetch('text').strip.to_i
    user = params.fetch('user_name')
    #TODO: Validate param

    if text < 51
      if text < 21 && text > 0
        r = "Fire #{text} is *FIRE EXTINGUISHED*, +0 dmg"
      elsif text < 35 && text > 20
        r = "Fire #{text} is *MINOR BURN*, +2 dmg"
      elsif text < 46 && text > 35
        r = "Fire #{text} is *MODERATE BURN*, +4 dmg"
      elsif text < 50 && text > 45
        r = "Fire #{text} is *SEVERE BURN*, +8 dmg"
      elsif text == 50
        r = "Fire #{text} is *IMMOLATED*, +100 dmg"
      else
        "Sorry, I have no idea what #{text} is. Try to do fewer drugs, #{user.upcase}."
      end
    else
      attack_data = Attack.find_by_attack_code(text)
      if attack_data.nil?
        "Sorry, I have no idea what #{text} is. Try to do fewer drugs, #{user.upcase}."
      else
        attack_data = attack_data.weaponize
        r = "Attack #{text} [#{attack_data['weapon']}] is *#{attack_data['text']}*, +#{attack_data['damage']} dmg"
      end
    end

    render text: r
  end

  def slack_bio
    character = params.fetch('text').strip
    output = ''
    chars = Character.find_by_full_name(character)

    if chars.nil?
      output = "Couldn't find any characters named #{character}"
    else
      chars.each do |char|
        output << "*#{char.first_name} #{char.last_name}*, #{Character.pretty_area(char.home_area)} "
        output << "[#{char.owner_name}]\n"
        output << "<#{char.bio_thread}>"
      end
    end

    render text: output
  end
end