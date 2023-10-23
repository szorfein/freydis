# frozen_string_literal: true

require 'mods/msg'
require_relative 'secrets/gpg'
require_relative 'secrets/archive'

module Freydis
  module Secrets
    extend Msg

    def self.backup
      DiskLuks.open
      info 'Backup secrets...'
      gpg = GPG.new
      archive = Archive.new(gpg)
      archive.create
      DiskLuks.close
    end

    def self.restore
      DiskLuks.open
      info 'Restoring secrets...'
      gpg = GPG.new
      archive = Archive.new(gpg)
      archive.restore
      DiskLuks.close
    end
  end
end
