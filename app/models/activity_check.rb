class ActivityCheck < ActiveRecord::Base
  has_and_belongs_to_many :characters

  def is_active?
    Time.now.to_i > self.opens_on.to_i && Time.now.to_i < self.closes_on.to_i
  end

  def can_open_new?
    all_checks = ActivityCheck.all
    all_checks.each do |check|
      if check.is_active? || (check[:opens_on].to_i > self.opens_on.to_i && check[:closes_on].to_i < self.opens_on.to_i)
        # can only have one check open at a time
        return false
      end
    end

    true
  end

  def previous_check_id
    if id > 1
      id - 1
    else
      1
    end
  end
end
