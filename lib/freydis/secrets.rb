# frozen_string_literal: true

require_relative 'secrets/gpg'
require_relative 'secrets/archive'

module Freydis
  module Secrets
    def self.backup
      DiskLuks.open
      Msg.info 'Backup secrets...'
      gpg = GPG.new
      archive = Archive.new(gpg)
      archive.create
      DiskLuks.close
    end

    def self.restore
      DiskLuks.open
      Msg.info 'Restoring secrets...'
      gpg = GPG.new
      archive = Archive.new(gpg)
      archive.restore
      DiskLuks.close
    end
  end
end
