class User < ActiveRecord::Base
  has_many :characters
  has_secure_password


  class << self

    def find_by_email_or_username(email_or_username)
      user = User.find_by_email(email_or_username)
      user ||= User.find_by_username(email_or_username)
    end

    def can_edit?(user_id)
      user = User.find_by_id(user_id)

      session[:user_id] == user_id || Rails.application.config.staff_permissions[:account_edit].include?(user.group)

    end

  end


end
