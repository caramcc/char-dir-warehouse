module Warehouse
  class Tessera < ActiveRecord::Base
    has_one :character
    has_one :reaping_check
  end
end