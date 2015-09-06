class Character < ActiveRecord::Base
  # attr_accessor :id, :owner_id, :first_name, :last_name, :bio_thread, :age, :home_area, :special, :gender, :fc_first,
  #               :fc_last, :char_approved, :fc_approved
  # flags: fc_flagged (fc_flag), char_flagged (char_flag), shared_fc_owner_id (is a user_id), is_dead, is_tribute, games_number

  belongs_to :user
  belongs_to :tessera
  has_and_belongs_to_many :reaping_checks
  has_and_belongs_to_many :activity_checks

  @allowed_areas = (1..13).to_a.concat %w(Capitol Wanderer)
  @special_types = %w(Avox Peacekeeper Gamemaker Victor Mayor Tribute)

  validates :first_name, presence: true
  validates :age, :numericality => {:only_integer => true, less_than: 130}
  # validates :home_area, inclusion: @allowed_areas
  # validates :special, inclusion: @special_types
  validates_url_format_of :bio_thread, allow_nil: false, message: 'invalid url format'

  def approve
    self.char_approved = true
    self.char_flagged = false
    self.char_flag = nil
    self.save
  end

  def add_flag(flag)
    self.char_flagged = true
    self.char_flag = flag
    self.save
  end


  def owner_name
    User.find_by_id(user_id).display_name
  end

  def approve_fc
    self.fc_approved = true
    self.save
  end

  def is_reapable?
    unreapable_specials = %w(Peacekeeper Victor Mayor)
    ('1'..'12').include?(self.home_area) && !unreapable_specials.include?(self.special) && (12..18).include?(self.age) &&
        self.char_approved && self.gender != 'Other'
  end


  def in_reaping?
    if ReapingCheck.last.nil?
      false
    else
      ReapingCheck.last.is_active? && self.reaping_checks.exists?(ReapingCheck.last)
    end
  end

  def is_active?
    if ActivityCheck.last.nil?
      false
    else
      self.activity_checks.exists?(ActivityCheck.last)
    end
  end

  def active_tessera
    Tessera.where(character_id: self.id, reaping_check_id: ReapingCheck.current_games_id).first
  end

  # returns "should the tessera be approved?"
  def update_tessera(number)
    if number.blank?
      true #
    else
      tessera = self.active_tessera
      if tessera.nil?
        tessera = Tessera.new
        tessera.character_id = self.id
        tessera.reaping_check_id = ReapingCheck.current_games_id
        tessera.previous_number =  0
      elsif tessera.approved
        tessera.previous_number = tessera.number
      end

      tessera.approved = tessera.previous_number == number.to_i
      tessera.number = number
      tessera.save
      false
    end
  end

  def approve_tessera(boolean)
    unless boolean.blank?
      tessera = self.active_tessera
      tessera ||= Tessera.new
      tessera.approved = boolean
      tessera.save
    end
  end

  def remove_from_reaping
    self.reaping_checks.destroy(ReapingCheck.last)
  end

  class << self
    def pretty_area(area)
      ('1'..'13').include?(area) ? "District #{area}" : area.capitalize
    end

    def find_by_full_name(full_name)
      full_name = full_name.gsub("'", '%')
      Character.where("LOWER(CONCAT(first_name, ' ', last_name)) LIKE '%#{full_name.downcase}%'")
    end

  end

end
