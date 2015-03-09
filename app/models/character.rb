class Character < ActiveRecord::Base
  attr_accessor :id, :owner_id, :first_name, :last_name, :bio_thread, :age, :home_area, :gender, :fc_first,
                :fc_last, :char_approved, :fc_approved
end
