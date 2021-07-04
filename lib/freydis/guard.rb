module Freydis::Guard
  def self.disk(name)
    raise Freydis::InvalidDisk, "No disk, use with -d DISK." unless name
    raise Freydis::InvalidDisk, "No disk, use with -d DISK." if name =~ /nil/
    raise Freydis::InvalidDisk, "Bad name #{name}, should match with sd[a-z]" unless name.match(/^sd[a-z]{1}$/)
    raise Freydis::InvalidDisk, "No disk /dev/#{name} available." unless File.exist? "/dev/#{name}"
    name
  rescue Freydis::InvalidDisk => e
    puts "#{e.class} => #{e}"
    exit 1
  end

  def self.isLuks(disk)
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

  def self.path?(p)
    raise Freydis::InvalidPath, "#{p} does not exist." unless File.exist? p
  rescue Freydis::InvalidPath => e
    puts "#{e.class} => #{e}"
    exit 1
  end
end
