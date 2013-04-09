require 'minitest/autorun'

class SomeTest < MiniTest::Unit::TestCase
  def setup
    @we_have_tests = false
  end

  def test_need_some_tests
    assert_equal true,  @we_have_tests
  end
end
