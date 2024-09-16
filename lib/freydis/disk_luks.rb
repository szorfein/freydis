# frozen_string_literal: true

require 'mods/msg'

module Freydis
  module DiskLuks
    extend Msg
    module_function

    def encrypt(opts)
      cryptsetup = Cryptsetup.new(opts[:disk])
      cryptsetup.encrypt
      cryptsetup.open
      cryptsetup.format
      cryptsetup.close
      success "Disk #{opts[:disk]} fully encrypted."
    end

    def open(opts)
      cryptsetup = Cryptsetup.new(opts[:disk])
      if opts[:disk_is_encrypt]
        cryptsetup.close
        cryptsetup.open
      end
      cryptsetup.mount
      success "Disk #{opts[:disk]} opened."
    end

    def close(opts)
      cryptsetup = Cryptsetup.new(opts[:disk])
      cryptsetup.umount
      cryptsetup.close if opts[:disk_is_encrypt]
      success "Disk #{opts[:disk]} closed."
    end
  end
end
