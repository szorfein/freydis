# lib/cryptsetup.rb

module Freydis
  class Cryptsetup
    def initialize(data)
      @data = data
      @dev_ids = [
        "/dev/disk/by-id/" + @data.options[:disk_id] ||= " ",
        "/dev/disk/by-uuid/" + @data.options[:disk_uuid] ||= " ",
        "/dev/disk/by-partuuid/" + @data.options[:disk_partuuid] ||= " ",
        "/dev/" + @data.options[:disk]
      ]
      @mapper_name = "freydis-enc"
      @mountpoint ="/mnt/freydis"
    end

    def encrypt
      @dev_ids.each { |f|
        if File.exists? f
          exec "cryptsetup -v --type luks2 --verify-passphrase luksFormat #{f}"
          break if $?.success?
        end
      }
    end

    def open
      @dev_ids.each { |f|
        if File.exists? f
          exec "cryptsetup -v open #{f} #{@mapper_name}"
          break if $?.success?
        end
      }
    end

    def close
      umount
      exec "cryptsetup -v close #{@mapper_name}" if File.exists? "/dev/mapper/#{@mapper_name}"
    end

    def format
      exec "mkfs.ext4 /dev/mapper/#{@mapper_name}"
    end

    def mount
      create_mountpoint
      puts "Mounting disk at #{@mountpoint}"
      exec "mount -t ext4 /dev/mapper/#{@mapper_name} #{@mountpoint}"
    end

    private

    def create_mountpoint
      if Process.uid === 0
        Dir.mkdir @mountpoint unless Dir.exist? @mountpoint
      else
        exec "mkdir -p #{@mountpoint}" unless Dir.exist? @mountpoint
      end
    end

    def umount
      dir_length = Dir.glob(@mountpoint).length
      if dir_length >= 1 # should contain lost+found if mount
        exec "umount #{@mountpoint}"
      end
    end

    def exec(command)
      sudo = Process.uid != 0 ? 'sudo' : ''
      if system("#{sudo} #{command}")
        puts "#{command} done."
      else
        raise StandardError, "[-] #{command}"
      end
    end
  end
end
