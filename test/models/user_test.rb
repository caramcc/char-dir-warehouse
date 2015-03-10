require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test 'check permissions' do
    assert_equal 'admin', @aya[:group]
    assert_equal 'librarian', @kay[:group]
    assert_equal 'member', @anyuser[:group]
  end

end
