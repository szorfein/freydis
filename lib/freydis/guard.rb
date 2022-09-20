# frozen_string_literal: true

module Freydis
  module Guard
    module_function

    def disk(name)
      full_path = "/dev/#{name}"
      raise Freydis::InvalidDisk, 'No disk, use with -d DISK.' unless name
      raise Freydis::InvalidDisk, 'No disk, use with -d DISK.' if name == ''
      raise Freydis::InvalidDisk, 'Bad name #{name}, should match with sd[a-z]' unless name.match(/^sd[a-z]{1}$/)
      raise Freydis::InvalidDisk, "No disk #{full_path} available." unless File.exist? full_path
      Freydis::Disk.new(full_path).search_id # return disk(name) by-id
    rescue Freydis::InvalidDisk => e
      puts "#{e.class} => #{e}"
      exit 1
    end

    def disk_id(name)
      raise DiskId, "No disk #{name} found." unless File.exist? name
    rescue Freydis::DiskId => e
      puts "#{e.class} => #{e}"
      exit 1
    end

    def isLuks(disk)
      raise Freydis::InvalidLuksDev, "No disk." unless disk
      raise Freydis::InvalidLuksDev, "#{disk} does not exist." unless File.exist? disk
      sudo = Process.uid != 0 ? 'sudo' : ''
      if !system(sudo, 'cryptsetup', 'isLuks', disk)
        raise Freydis::InvalidLuksDev, "#{disk} is not valid Luks device."
      end
    rescue Freydis::InvalidLuksDev => e
      puts "#{e.class} => #{e}"
      exit 1
    end

    def path?(p)
      raise Freydis::InvalidPath, "#{p} does not exist." unless File.exist? p
    rescue Freydis::InvalidPath => e
      puts "#{e.class} => #{e}"
      exit 1
    end

    def gpg(recipient)
      raise Freydis::GPG, "No recipient, use --gpg-recipient NAME" unless recipient
      recipient
    rescue Freydis::GPG => e
      puts "#{e.class} => #{e}"
      exit 1
    end
  end
end
