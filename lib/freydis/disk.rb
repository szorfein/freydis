# lib/disk.rb

module Freydis
  class Disk
    def initialize(dev)
      @disk = Freydis::Guard.disk(dev)
      @dev = "/dev/#{@disk}"
    end

    def size
      `lsblk -dno SIZE #{@dev}`.chomp
    end

    def complete_info
      `lsblk -dno "NAME,LABEL,FSTYPE,SIZE" #{@dev}`.chomp
    end

    def populate_data(data)
      puts "Checking IDs on #{@disk}..."
      data.options[:disk_uuid] = search_uuid
      data.options[:disk_id] = search_id
      data.options[:disk_partuuid] = search_partuuid
    end

    def encrypt(data)
      search_id(data)
      puts "id -> #{data.options[:disk_id]}"
      data.save

      cryptsetup = Freydis::Cryptsetup.new(data)
      cryptsetup.close

      cryptsetup.encrypt
      cryptsetup.open
      cryptsetup.format

      populate_data(data)
      puts "uuid -> #{data.options[:disk_uuid]}"
      puts "partuuid -> #{data.options[:disk_partuuid]}"
      data.save

      cryptsetup.close
    end

    def search_partuuid
      Dir.glob("/dev/disk/by-partuuid/*").each { |f|
        if File.readlink(f).match(/#{@disk}/)
          return f.delete_prefix("/dev/disk/by-partuuid/")
        end
      }
    end

    def search_uuid
      Dir.glob("/dev/disk/by-uuid/*").each { |f|
        if File.readlink(f).match(/#{@disk}/)
          return f.delete_prefix("/dev/disk/by-uuid/")
        end
      }
    end

    def search_id
      Dir.glob("/dev/disk/by-id/*").each { |f|
        if File.readlink(f).match(/#{@disk}/)
          return f.delete_prefix("/dev/disk/by-id/")
        end
      }
    end
  end
end
