class User < ActiveRecord::Base
  # attr_accessor :id, :username, :display_name, :email, :password_digest, :group
  has_many :characters
  has_secure_password


  class << self

    def find_by_email_or_username(email_or_username)
      user = User.find_by_email(email_or_username)
      user ||= User.find_by_username(email_or_username)

      user
    end

  #
  #   def initialize(username, email, password)
  #     user = User.new
  #     @username = username
  #
  #   end
  #
  #   def from_hash(h)
  #     user = User.new
  #     h_clone = h.deep_dup
  #
  #     if h_clone.nil?
  #       return user
  #     end
  #
  #     h_clone.each do |k, v|
  #       if User.method_defined?("#{k}")
  #         user.instance_variable_set("#{k}", v)
  #       end
  #     end
  #
  #   end
  #
  #

  end


end
