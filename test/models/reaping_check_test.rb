require 'test_helper'

class ReapingCheckTest < ActiveSupport::TestCase
  test 'is active' do
    assert @open.is_active?
  end
end
