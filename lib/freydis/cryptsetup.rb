# frozen_string_literal: true

require 'fileutils'

module Freydis
  class Cryptsetup
    def initialize
      Guard.disk_id(CONFIG.disk)

      @disk = Disk.new(CONFIG.disk).search_sdx
      @mapper_name = 'freydis-encrypt'
      @mountpoint = '/mnt/freydis'
    end

    def encrypt
      Msg.info "Encrypting disk #{@disk}..."
      exec "cryptsetup -v --type luks2 --verify-passphrase luksFormat #{@disk}"
    end

    def open
      Msg.info "Opening disk #{@mapper_name}..."
      exec "cryptsetup -v open #{@disk} #{@mapper_name}"
    end

    def close
      umount
      if File.exist? "/dev/mapper/#{@mapper_name}"
        exec "cryptsetup -v close #{@mapper_name}"
      else
        Msg.info "#{@mapper_name} is not open."
      end
    end

    def format
      Msg.info "Formatting #{@mapper_name}..."
      exec "mkfs.ext4 /dev/mapper/#{@mapper_name}"
    end

    def mount
      create_mountpoint
      Msg.info "Mounting disk at #{@mountpoint}"
      exec "mount -t ext4 /dev/mapper/#{@mapper_name} #{@mountpoint}"
    end

    protected

    def umount
      if mounted?
        exec "umount #{@mountpoint}"
        Msg.success "Umounting disk #{@disk}..."
      else
        Msg.info "Disk #{@disk} is no mounted."
      end
    end

    private

    def create_mountpoint
      if Process.uid == 0
        FileUtils.mkdir_p @mountpoint
      else
        exec "mkdir -p #{@mountpoint}"
      end
    end

    def mounted?
      File.open('/proc/mounts') do |f|
        f.each do |line|
          return true if line.match?(/#{@mountpoint}/)
        end
      end
      false
    end

    def exec(command)
      sudo = Process.uid != 0 ? 'sudo' : ''
      if !system("#{sudo} #{command}")
        Msg.error "Execute: #{command}"
      end
    end
  end
end
