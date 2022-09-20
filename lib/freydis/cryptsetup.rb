# frozen_string_literal: true

require 'fileutils'
require 'mods/exec'
require 'mods/msg'

module Freydis
  class Cryptsetup
    include Exec
    include Msg

    def initialize
      Guard.disk_id(CONFIG.disk)

      @disk = Disk.new(CONFIG.disk).search_sdx
      @mapper_name = 'freydis-encrypt'
      @mountpoint = '/mnt/freydis'
    end

    def encrypt
      info "Encrypting disk #{@disk}..."
      x "cryptsetup -v --type luks2 --verify-passphrase luksFormat #{@disk}"
    end

    def open
      info "Opening disk #{@mapper_name}..."
      x "cryptsetup -v open #{@disk} #{@mapper_name}"
    end

    def close
      umount
      if File.exist? "/dev/mapper/#{@mapper_name}"
        x "cryptsetup -v close #{@mapper_name}"
      else
        info "#{@mapper_name} is not open."
      end
    end

    def format
      info "Formatting #{@mapper_name}..."
      x "mkfs.ext4 /dev/mapper/#{@mapper_name}"
    end

    def mount
      create_mountpoint
      info "Mounting disk at #{@mountpoint}"
      x "mount -t ext4 /dev/mapper/#{@mapper_name} #{@mountpoint}"
    end

    protected

    def umount
      if mounted?
        x "umount #{@mountpoint}"
        success "Umounting disk #{@disk}..."
      else
        info "Disk #{@disk} is no mounted."
      end
    end

    private

    def create_mountpoint
      if Process.uid == 0
        FileUtils.mkdir_p @mountpoint
      else
        x "mkdir -p #{@mountpoint}"
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
  end
end
