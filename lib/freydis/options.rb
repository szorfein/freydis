# frozen_string_literal: true

require 'optparse'

module Freydis
  class Options
    def initialize(argv)
      parse(argv)
    end

    private

    def parse(argv)
      OptionParser.new do |opts|
        opts.banner = 'Usage: freydis.rb [options]'
        opts.version = VERSION

        opts.on('--disk NAME', /^sd[a-z]$/, 'Use the disk NAME (e.g: sda, sdb).') do |disk|
          Freydis::CONFIG.disk = Freydis::Guard.disk(disk)
        end

        opts.on('-p PATHS', '--paths-add PATHS', Array, 'Add absolute PATHS to the backup list.') do |paths|
          paths.each do |p|
            Freydis::Guard.path? p
            Freydis::CONFIG.paths << p
          end

        end

        opts.on('-d PATH', '--path-del PATH', String, 'Remove absolute PATH from the backup list.') do |p|
          Freydis::Guard.path? p
          Freydis::CONFIG.paths.delete p if CONFIG.paths.include? p
        end

        opts.on('-L', '--paths-list', 'List all paths from your list.') do
          if Freydis::CONFIG.paths.nil?
            puts 'Nothing in paths yet...'
          else
            puts Freydis::CONFIG.paths
          end
        end

        # Engines options

        opts.on('-e', '--encrypt', 'Encrypt and format (ext4) your device.') do
          Freydis::DiskLuks.encrypt
        end

        opts.on('-o', '--open', 'Open and mount encrypted disk at /mnt/freydis.') do
          Freydis::DiskLuks.open
        end

        opts.on('-c', '--close', 'Umount and close encrypted disk.') do
          Freydis::DiskLuks.close
        end

        opts.on('-b', '--backup', 'Perform a backup.') do
          Freydis::Rsync.new.backup
        end

        opts.on('-r', '--restore', 'Restore saved datas on your system.') do
          Freydis::Rsync.new.restore
        end

        opts.on('-s', '--save', 'Save current arguments in the config file.') do
          Freydis::CONFIG.save
        end

        begin
          opts.parse!(argv)
        rescue OptionParser::ParseError => e
          warn e.message, "\n", opts
          exit 1
        end
      end
    end
  end
end
