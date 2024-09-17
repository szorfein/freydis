# frozen_string_literal: true

module Freydis
  # Guard control argument/path/input and quit if no valid
  module Guard
    module_function

    def disk(name)
      raise Freydis::InvalidDisk, 'No disk, use with --disk PATH.' unless name
      raise Freydis::InvalidDisk, 'No disk, use with --disk PATH.' if name == ''
      raise Freydis::InvalidDisk, "No disk #{name} available." unless File.exist? name

      name
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

    def luks?(disk)
      raise Freydis::InvalidLuksDev, 'No disk, use with --disk PATH.' unless disk
      raise Freydis::InvalidLuksDev, "#{disk} does not exist." unless File.exist? disk

      sudo = Process.uid != 0 ? 'sudo' : ''
      unless system(sudo, 'cryptsetup', 'isLuks', disk)
        raise Freydis::InvalidLuksDev, "#{disk} is not valid Luks device."
      end
    rescue Freydis::InvalidLuksDev => e
      puts "#{e.class} => #{e}"
      exit 1
    end

    def path?(path)
      raise Freydis::InvalidPath, "#{path} does not exist." unless File.exist? path
    rescue Freydis::InvalidPath => e
      puts "#{e.class} => #{e}"
      exit 1
    end
  end
end
