# frozen_string_literal: true

require_relative 'freydis/version'
require_relative 'freydis/options'
require_relative 'freydis/init'
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

    private

    def init_config
      return unless @cli[:init]
      Init.run(@cli)
      save
    end

    def backup
      return unless @cli[:backup]
      raise ArgumentError, "No paths to backup" unless @cli[:paths]
      raise ArgumentError, "No paths to backup" if @cli[:paths] === []

      puts " ==> Backup on #{@cli[:disk]}..."
      disk = DiskLuks.new(@cli)
      disk.open
      rsync = Rsync.new(@cli)
      rsync.backup
      disk.close
    end

    def restoring
      return unless @cli[:restore]
      puts
      puts " ===> Restoring..."
      disk = DiskLuks.new(@cli)
      disk.open
      rsync = Rsync.new(@cli)
      rsync.restore
      disk.close
    end
  end
end
