require_relative 'freydis/version'
require_relative 'freydis/options'
require_relative 'freydis/init'
require_relative 'freydis/data'
require_relative 'freydis/disk'
require_relative 'freydis/cryptsetup'
require_relative 'freydis/rsync'
require_relative 'freydis/guard'

module Freydis
  class Main
    def initialize(args)
      @data = Data.new(args[:data_file])
      @data.load!
      @cli = args[:cli].options
      @disk = @cli[:disk] ||= @data.options[:disk]
    end

    def start
      puts "Freydis v." + VERSION
      bye if @cli === []
      init_config
      encrypt_disk
      backup
      restoring
      opening
      closing
    end

    def bye
      puts "Bye !"
      exit 0
    end

    private

    def init_config
      return unless @cli[:init]
      Init.run(@data.options)
      @data.save
    end

    def encrypt_disk
      return unless @cli[:encrypt]
      puts "Encrypting disk #{@disk}..."
      disk = Disk.new(@disk)
      disk.encrypt(@data)
      @data.save
    end

    def backup
      return unless @cli[:backup]
      puts "Saving..."
      disk = Disk.new(@disk)
      disk.open(@data)
      rsync = Rsync.new(@data)
      rsync.backup
      disk.close(@data)
    end

    def restoring
      return unless @cli[:restore]
      puts "Restoring..."
      disk = Disk.new(@disk)
      disk.open(@data)
      rsync = Rsync.new(@data)
      rsync.restore
      disk.close(@data)
    end

    def opening
      return unless @cli[:open]
      puts "Opening disk #{@disk}."
      disk = Disk.new(@disk)
      disk.open(@data)
    end

    def closing
      return unless @cli[:close]
      puts "Closing disk #{@disk}."
      disk = Disk.new(@disk)
      disk.close(data)
    end
  end
end

