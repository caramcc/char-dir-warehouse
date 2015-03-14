class User < ActiveRecord::Base
  has_many :characters
  has_secure_password

  def admin_panel?
    Rails.application.config.staff_permissions[:admin_panel].include?(self.group)
  end

  def can_edit?
    session[:user_id] == self.id || Rails.application.config.staff_permissions[:account_edit].include?(self.group)
  end

  class << self

    def find_by_email_or_username(email_or_username)
      user = User.find_by_email(email_or_username)
      user ||= User.find_by_username(email_or_username)
    end

  end


end
