# frozen_string_literal: true

require 'mods/msg'

module Freydis
  module DiskLuks
    extend Msg
    module_function

    def encrypt
      cryptsetup = Freydis::Cryptsetup.new
      cryptsetup.encrypt
      cryptsetup.open
      cryptsetup.format
      cryptsetup.close
      success "Disk #{OPTIONS[:disk]} fully encrypted."
    end

    def open
      cryptsetup = Freydis::Cryptsetup.new
      cryptsetup.close
      cryptsetup.open
      cryptsetup.mount
      success "Disk #{OPTIONS[:disk]} opened."
    end

    def close
      cryptsetup = Freydis::Cryptsetup.new
      cryptsetup.close
      success "Disk #{OPTIONS[:disk]} closed."
    end
  end
end
