class Character < ActiveRecord::Base
  # attr_accessor :id, :owner_id, :first_name, :last_name, :bio_thread, :age, :home_area, :special, :gender, :fc_first,
  #               :fc_last, :char_approved, :fc_approved

  belongs_to :user
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
    self.save
  end

  def approve_fc
    self.fc_approved = true
    self.save
  end

  def is_reapable?
    unreapable_specials = %w(Peacekeeper Victor Mayor)
    ('1'..'12').include?(self.home_area) && !unreapable_specials.include?(self.special) && (12..18).include?(self.age) &&
        self.char_approved
  end

end
