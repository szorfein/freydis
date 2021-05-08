# lib/cryptsetup.rb

module Freydis
  class Cryptsetup
    def initialize(data)
      raise StandardError, "Bad uuid #{uuid}" unless File.exists? "/dev/disk/by-uuid/#{uuid}"
      @uuid = uuid
      @name = "freydis-enc"
    end

    def encrypt
      exec "cryptsetup -v --type luks2 --verify-passphrase luksFormat /dev/disk/by-uuid/#{@uuid}"
      raise StandardError, "encrypt #{@uuid}" unless $?.exitstatus == 0
    end

    def open
      `sudo cryptsetup -v open "#{@uuid}" #{@name}`
    end

    def close
      `sudo cryptsetup -v close #{@name}`
    end

    private
    def exec(command)
      system("sudo #{command}")
    end
  end
end
