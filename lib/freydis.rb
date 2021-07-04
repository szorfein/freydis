require_relative 'freydis/version'
require_relative 'freydis/options'
require_relative 'freydis/init'
require_relative 'freydis/data'
require_relative 'freydis/disk'
require_relative 'freydis/disk_luks'
require_relative 'freydis/cryptsetup'
require_relative 'freydis/rsync'
require_relative 'freydis/guard'
require_relative 'freydis/error'

module Freydis
  class Main
    def initialize(args)
      @config = args[:config]
      @cli = args[:cli].options
      @disk = @cli[:disk]

      Freydis::Guard.disk(@cli[:disk])
    end

    def start
      init_config
      encrypt_disk
      backup
      restoring
      opening
      closing
      save if @cli[:save]
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

    def encrypt_disk
      return unless @cli[:encrypt]
      puts "Encrypting disk #{@disk}..."
      disk = Disk.new(@disk)
      disk.encrypt(@data)
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

    def opening
      return unless @cli[:open]
      puts
      puts " ===> Opening disk #{@disk}."
      disk = DiskLuks.new(@cli)
      disk.open
    end

    def closing
      return unless @cli[:close]
      puts
      puts " ===> Closing disk #{@disk}."
      disk = DiskLuks.new(@cli)
      disk.close
    end

    def save
      puts
      puts " ===> Saving options to #{@config}..."
      Data.new(@config, @cli).save
    end
  end
end

