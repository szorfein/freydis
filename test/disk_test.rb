require 'minitest/autorun'
require 'freydis'

class TestDisk < Minitest::Test
  def setup
    @disk = Freydis::Disk.new('sda')
  end

  def test_lsblk_display_size_in_gigabytes
    assert_match(/G$/i, @disk.size)
  end

  def test_valid_partuuid
    puuid = @disk.search_partuuid
    assert_match(/[\w]{8}-[\w]{4}-[\w]{4}-[\w]{4}-[\w]{12}$/, puuid)
  end

  def raise_an_error_if_no_disk
    assert_raises "Freydis::InvalidDisk => No disk." do
      Freydis::Guard.new(nil)
    end
  end
end
