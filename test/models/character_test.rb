require 'test_helper'

class CharacterTest < ActiveSupport::TestCase


  test 'character approval' do
    assert !@dom.char_approved
    @dom.approve
    assert @dom.char_approved
  end

  test 'is_reapable?' do
    assert @katniss.is_reapable?, 'expected katniss to be reapable'
    assert !@dom.is_reapable?, 'expected dom not to be reapable (capitol, old)'
    assert !@arbor.is_reapable?, 'expected arbor not to be reapable (old, victor)'
    assert !@saffron.is_reapable?, 'expected saffron not to be reapable (victor)'
    assert !@bartholomew.is_reapable?, 'expected bartholomew not to be reapable (old)'
    assert !@child.is_reapable?, 'expected child not to be reapable (young)'
    assert !@capitolite.is_reapable?, 'expected capitolite not to be reapable (area)'
  end

end
