# frozen_string_literal: true

require_relative 'freydis/version'
require_relative 'freydis/options'
require_relative 'freydis/config'
require_relative 'freydis/disk'
require_relative 'freydis/disk_luks'
require_relative 'freydis/cryptsetup'
require_relative 'freydis/rsync'
require_relative 'freydis/error'
require_relative 'freydis/guard'
require_relative 'freydis/secrets'
require_relative 'freydis/main'

module Freydis
  OPTIONS = {
    disk: '',
    gpg_recipient: '',
    backup_paths: []
  }

  ACTIONS = {
    encrypt: false,
    open: false,
    close: false,
    backup: false,
    restore: false,
    secrets_backup: false,
    secrets_restore: false,
    config_save: true
  }

  # Load options from YAML
  Config.new.load

  # If problem with the config load
  OPTIONS[:backup_paths] = [] if OPTIONS[:backup_paths] == nil
end
