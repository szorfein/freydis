# frozen_string_literal: true

require_relative 'freydis/version'
require_relative 'freydis/config'
require_relative 'freydis/disk'
require_relative 'freydis/disk_luks'
require_relative 'freydis/cryptsetup'
require_relative 'freydis/rsync'
require_relative 'freydis/error'
require_relative 'freydis/guard'

# Freydis - tool to backup data using rsync, cryptsetup.
module Freydis
end
