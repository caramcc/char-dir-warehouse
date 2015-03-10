class User < ActiveRecord::Base
  attr_accessor :id, :username, :display_name, :email, :password, :salt, :group

  has_many :characters

end
