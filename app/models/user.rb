class User < ActiveRecord::Base
  has_many :characters
  has_secure_password


  class << self

    def find_by_email_or_username(email_or_username)
      user = User.find_by_email(email_or_username)
      user ||= User.find_by_username(email_or_username)

      user
    end


  end


end
