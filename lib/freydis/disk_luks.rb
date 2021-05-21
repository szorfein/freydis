# lib/disk_luks.rb

module Freydis
  class DiskLuks < Disk
    def initialize(disk, data)
      @disk = disk ||= nil
      @data = data
      if @disk
        Freydis::Guard.disk(@disk)
        Freydis::Guard.isLuks(@disk)
        @data.options[:disk] = @disk
        populate_data(@data)
      elsif @data.options[:disk_id] != ''
        Freydis::Guard.isLuks("/dev/disk/by-id/#{@data.options[:disk_id]}")
      else
        puts "No disk."
        exit 1
      end
    end

    def open
      cryptsetup = Freydis::Cryptsetup.new(@data)
      cryptsetup.close
      cryptsetup.open
      cryptsetup.mount
    end

    def close
      cryptsetup = Freydis::Cryptsetup.new(@data)
      cryptsetup.close
    end
  end
end
