require 'test_helper'

class CharacterTest < ActiveSupport::TestCase


  test 'character approval' do
    assert !@dom.char_approved
    @dom.approve
    assert @dom.char_approved
  end

end
