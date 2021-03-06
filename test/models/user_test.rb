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

  test 'can_edit? method' do
    assert @anyuser.can_edit?(@anyuser)
    assert @aya.can_edit?(@anyuser)
    assert @aya.can_edit?(@aya)
    assert @aya.can_edit?(@arbor)
    assert !@anyuser.can_edit?(@arbor)
    assert @anyuser.can_edit?(@bartholomew)
  end

  test 'can_approve' do
    assert @aya.can_approve?
    assert @kay.can_approve?
    assert !@anyuser.can_approve?
  end

  test 'reaping_tickets' do
    assert_equal 22, @aya.reaping_tickets
    assert_equal 10, @kay.reaping_tickets
    assert_equal 13, @anyuser.reaping_tickets
  end

end
