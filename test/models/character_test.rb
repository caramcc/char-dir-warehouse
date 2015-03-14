require 'test_helper'

class CharacterTest < ActiveSupport::TestCase

  test 'fixtures' do

    assert_equal 1, Character.count
    assert_equal 30, @arbor[:age]

  end


end
