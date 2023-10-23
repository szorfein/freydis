# frozen_string_literal: true

module Freydis
  class Disk
    def initialize(disk_path)
      raise ArgumentError, "#{disk_path} no valid" unless disk_path.match?(/^\/dev\//)

      @disk = disk_path
    end

    def size
      `lsblk -dno SIZE #{@disk}`.chomp
    end

    def complete_info
      `lsblk -dno "NAME,LABEL,FSTYPE,SIZE" #{@disk}`.chomp
    end

    def search_id
      dev_split = @disk.delete_prefix('/dev/')
      Dir.glob("/dev/disk/by-id/*").each do |f|
        return f if File.readlink(f).match?(/#{dev_split}/)
          #return f.delete_prefix("/dev/disk/by-id/")
      end
      raise ArgumentError, "Unable to find the disk id of #{@disk}."
    end

    # return /dev/sdX from a disk_id if value match with @disk
    def search_sdx
      Dir.glob('/dev/disk/by-id/*').each do |f|
        if f.match?(/#{@disk}$/) # need a space
          return '/dev/' + File.readlink(f).delete_prefix('../../')
        end
      end
      raise ArgumentError, "Unable to find the disk sdX of #{@disk}."
    end
  end
end
