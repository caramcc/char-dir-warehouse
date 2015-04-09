require 'test_helper'

class ReapingCheckTest < ActiveSupport::TestCase

  def setup
    @open.opens_on = Time.now.to_i - 1000
    @open.closes_on = Time.now.to_i + 1000
  end

  test 'is active' do
    assert @open.is_active?
  end
end
