class ReapingCheck < ActiveRecord::Base
  # t.timestamp :opens_on, t.timestamp :closes_on
  has_many :characters

  def is_active?
    Time.now.to_i > self.opens_on && Time.now.to_i < closes_on
  end
end
