require 'minitest/autorun'
require 'freydis'

class GuardTest < Minitest::Test
  def raise_error_if_void
    assert_raises "Freydis::InvalidDisk => No disk." do
      Freydis::Guard.new(nil)
    end
  end

  def raise_error_if_no_valid_disk
    assert_raises "Freydis::Invalid => Bad name Foo, should match with sd[a-z]" do
      Freydis::Guard.new('Foo')
    end
  end
end
