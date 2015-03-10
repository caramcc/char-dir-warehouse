class Character < ActiveRecord::Base
  attr_accessor :id, :owner_id, :first_name, :last_name, :bio_thread, :age, :home_area, :gender, :fc_first,
                :fc_last, :char_approved, :fc_approved

  belongs_to :user

  validates :first_name, presence: true
  validates_url_format_of :bio_thread, allow_nil: false, message: 'invalid url format'

end
