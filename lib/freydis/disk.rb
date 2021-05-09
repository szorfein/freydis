# lib/disk.rb

module Freydis
  class Disk
    def initialize(dev)
      @disk = dev.match(/sd[a-z]{1}/)
      @dev = "/dev/#{@disk}"
      @mountpoint = "/mnt/freydis"
    end

    def size
      `lsblk -dno SIZE #{@dev}`.chomp
    end

    def complete_info
      `lsblk -dno "NAME,LABEL,FSTYPE,SIZE" #{@dev}`.chomp
    end

    def populate_data(data)
      puts "Checking IDs on #{@disk}..."
      search_uuid(data)
      search_id(data)
      search_partuuid(data)
    end

    def encrypt(data)
      populate_data(data)
      puts "id -> #{data.options[:disk_id]}"
      puts "uuid -> #{data.options[:disk_uuid]}"
      puts "partuuid -> #{data.options[:disk_partuuid]}"
      data.save

      cryptsetup = Freydis::Cryptsetup.new(data)
      cryptsetup.close

      cryptsetup.encrypt
      cryptsetup.open
      cryptsetup.format

      cryptsetup.close
    end

    def open(data)
      cryptsetup = Freydis::Cryptsetup.new(data)
      cryptsetup.close
      cryptsetup.open
      cryptsetup.mount
    end

    def close(data)
      cryptsetup = Freydis::Cryptsetup.new(data)
      cryptsetup.close
    end

    private

    def search_uuid(data)
      Dir.glob("/dev/disk/by-uuid/*").each { |f|
        if File.readlink(f).match(/#{@disk}/)
          data.options[:disk_uuid] = f.delete_prefix("/dev/disk/by-uuid/")
        end
      }
    end

    def search_id(data)
      Dir.glob("/dev/disk/by-id/*").each { |f|
        if File.readlink(f).match(/#{@disk}/)
          data.options[:disk_id] = f.delete_prefix("/dev/disk/by-id/")
        end
      }
    end

    def search_partuuid(data)
      Dir.glob("/dev/disk/by-partuuid/*").each { |f|
        if File.readlink(f).match(/#{@disk}/)
          data.options[:disk_partuuid] = f.delete_prefix("/dev/disk/by-partuuid/")
        end
      }
    end
  end
end
