# frozen_string_literal: true

require 'optparse'
require 'mods/msg'

module Freydis
  class Options
    include Msg

    def initialize(argv)
      parse(argv)
    end

    private

    def parse(argv)
      OptionParser.new do |opts|
        opts.banner = 'Usage: freydis.rb [options]'
        opts.version = VERSION

        opts.on('--disk NAME', /^sd[a-z]$/,
                'Use the disk NAME (e.g: sda, sdb).') do |disk|
          OPTIONS[:disk] = Guard.disk(disk)
        end

        opts.on('--gpg-recipient NAME', String, 'Use gpg key NAME.') do |key|
          OPTIONS[:gpg_recipient] = Guard.gpg(key)
          info "Using key #{OPTIONS[:gpg_recipient]}"
        end

        opts.on('-p PATHS', '--paths-add PATHS', Array,
                'Add absolute PATHS to the backup list.') do |paths|
          paths.each do |p|
            Freydis::Guard.path? p

            info p
            OPTIONS[:backup_paths] << p unless OPTIONS[:backup_paths].include? p
          end
        end

        opts.on('-d PATH', '--path-del PATH', String,
                'Remove absolute PATH from the backup list.') do |p|
          Freydis::Guard.path? p

          if OPTIONS[:backup_paths].include? p
            OPTIONS[:backup_paths].delete p
          else
            error "#{p} is no found in #{OPTIONS[:backup_paths]}"
          end
        end

        opts.on('-L', '--paths-list', 'List all paths from your list.') do
          if OPTIONS[:backup_paths].nil?
            error 'Nothing in paths yet...'
          else
            success "Listing paths to backup..."
            OPTIONS[:backup_paths].each { |p| info p }
          end
        end

        # Engines options

        opts.on('-e', '--encrypt', 'Encrypt and format (ext4) your device.') do
          ACTIONS[:encrypt] = true
        end

        opts.on('-o', '--open', 'Open and mount encrypted disk at /mnt/freydis.') do
          ACTIONS[:open] = true
        end

        opts.on('-c', '--close', 'Umount and close encrypted disk.') do
          ACTIONS[:close] = true
        end

        opts.on('-b', '--backup', 'Perform a backup.') do
          ACTIONS[:backup] = true
        end

        opts.on('-r', '--restore', 'Restore saved datas on your system.') do
          ACTIONS[:restore] = true
        end

        opts.on('--secrets-backup', 'Backup only secrets, including GPG keys.') do |s|
          ACTIONS[:secrets_backup] = true
        end

        opts.on('--secrets-restore', 'Restore secrets.') do |s|
          ACTIONS[:secrets_restore] = true
        end

        opts.on('-s', '--save', 'Save current arguments in the config file.') do
          ACTIONS[:config_save] = true
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
