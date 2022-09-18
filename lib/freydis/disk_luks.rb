# frozen_string_literal: true

module Freydis
  module DiskLuks
    module_function

    def encrypt
      cryptsetup = Freydis::Cryptsetup.new
      cryptsetup.encrypt
      cryptsetup.open
      cryptsetup.format
      cryptsetup.close
      Msg.success "Disk #{CONFIG.disk} fully encrypted."
    end

    def open
      cryptsetup = Freydis::Cryptsetup.new
      cryptsetup.close
      cryptsetup.open
      cryptsetup.mount
      Msg.success "Disk #{CONFIG.disk} opened."
    end

    def close
      cryptsetup = Freydis::Cryptsetup.new
      cryptsetup.close
      Msg.success "Disk #{CONFIG.disk} closed."
    end
  end
end
