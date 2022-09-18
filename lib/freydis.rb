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
require_relative 'freydis/msg'

module Freydis
  CONFIG = Config.new
  CONFIG.load
  
  class Main
    def initialize(args)
      @argv = args[:argv]
    end

    def start
      Options.new(@argv)
    end

    def bye
      puts
      puts "Bye !"
      exit
    end
  end
end
