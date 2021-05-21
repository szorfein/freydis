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

  def test_should_raise_an_error
    error = assert_raises(Freydis::InvalidDisk) do 
      raise Freydis::InvalidDisk, 'Freydis::InvalidDisk => No Disk.'
    end

    assert_equal 'Freydis::InvalidDisk => No Disk.', error.message
  end
end
