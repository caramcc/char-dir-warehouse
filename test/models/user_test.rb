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

  test 'find by email or username' do
    assert_equal @aya.id, User.find_by_email_or_username('aya').id
    assert_equal @aya.id, User.find_by_email_or_username('dominate.earth@gmail.com').id
    assert_nil User.find_by_email_or_username('asdf')
  end

  test 'can_edit_account? method' do
    assert @anyuser.can_edit_account?(@anyuser)
    assert @aya.can_edit_account?(@anyuser)
    assert @aya.can_edit_account?(@aya)
  end

  test 'can_approve' do
    assert @aya.can_approve?
    assert @kay.can_approve?
    assert !@anyuser.can_approve?
  end

end
