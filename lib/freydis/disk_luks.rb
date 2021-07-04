# lib/disk_luks.rb

module Freydis
  class DiskLuks < Disk
    def initialize(data)
      @data = data
      @disk = data[:disk]
      if @disk
        if File.exist? "/dev/disk/by-id/#{@disk}"
          Freydis::Guard.disk("/dev/disk/by-id/#{@disk}")
          Freydis::Guard.isLuks("/dev/disk/by-id/#{@disk}")
        elsif File.exist? "/dev/#{@disk}"
          Freydis::Guard.disk(@disk)
          Freydis::Guard.isLuks("/dev/#{@disk}")
        else
          puts "#{@disk} value is not supported yet"
          exit
        end
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
