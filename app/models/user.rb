class User < ActiveRecord::Base
  has_many :characters
  has_many :combatants
  has_secure_password

  validates :email, :uniqueness => true
  validates :username, :uniqueness => true
  validates :display_name, :uniqueness => true

  def admin_panel?
    # Needed before Rails.application.config loads...
    %w(ADMIN LIBRARIAN MODERATOR).include?(self.group)
  end

  def can_edit?(char_or_user)
    if char_or_user.is_a?(Character)
      self.id == char_or_user.user_id || Rails.application.config.staff_permissions[:character_edit].include?(self.group)
    elsif char_or_user.is_a?(User)
      self.id == char_or_user.id || Rails.application.config.staff_permissions[:account_edit].include?(self.group)
    else
      raise ArgumentError "The provided parameter #{char_or_user} is not a Character or User."
    end
  end

  def can_approve?
    Rails.application.config.staff_permissions[:character_approve].include?(self.group)
  end

  def can_promote?
    # Rails.application.config.staff_permissions[:user_promote].include?(self.group)

    %w(ADMIN LIBRARIAN MODERATOR).include?(self.group)
  end

  def reaping_checks?
    %w(ADMIN LIBRARIAN).include?(self.group)
  end

  def reaping_tickets
  #   how many characters can this member enter into the reaping?
    non_reapables = 0
    self.characters.each do |char|
      unless char.is_reapable?
        if char.char_approved
          non_reapables += 1
        end
      end
    end

    10 + (non_reapables * 2)
  end

  def update_profile(params)
    if params.has_key?(:old_password)
      self.authenticate(params[:old_password])
      self.update(password: params[:new_password], password_confirmation: params[:confirm_new_password])
    end

    self.group = params[:group]
    self.group = params[:display_name]
    self.group = params[:email]
  end

  class << self

    def find_by_email_or_username(email_or_username)
      user = User.find_by_email(email_or_username)
      user ||= User.find_by_username(email_or_username)
      user ||= User.where('lower(username) = ?', email_or_username.downcase).first
    end

  end


end
