require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test 'check permissions' do
    assert_equal 'ADMIN', @aya[:group]
    assert_equal 'LIBRARIAN', @kay[:group]
    assert_equal 'MEMBER', @anyuser[:group]
  end

  test 'admin_panel? method' do
    assert @aya.admin_panel?
    assert !@anyuser.admin_panel?
  end

end
