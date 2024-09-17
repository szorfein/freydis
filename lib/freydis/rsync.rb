# frozen_string_literal: true

require 'mods/exec'

module Freydis
  # Interact with rsync from unix
  class Rsync
    include Exec

    def initialize(opts)
      @workdir = '/mnt/freydis/backup'
      @exclude_paths = %w['/dev/*' '/proc/*'
                          '/sys/*' '/tmp/*'
                          '/run/*' '/mnt/*'
                          '/media/*' '/home/*/.gvfs'
                          '/var/lib/dhcpcd/*' '*lost+found']
      @backup = opts[:backup_paths] || []
      @user_excludes = opts[:exclude_paths] || []
      @restore_at = opts[:restore_at] || '/'
      @opts = '-aAXHv --relative -hh'
    end

    def backup
      raise 'Nothing to backup, use --paths-add PATH' if @backup == []

      mkdir @workdir
      exil = combine_exclude
      save = @backup * ' '
      @opts += ' --delete --recursive'
      x "rsync #{@opts} --exclude={#{exil}} #{save} #{@workdir}"
      puts "Saved path #{save}"
    end

    def restore
      x "rsync #{@opts} #{@workdir} #{@restore_at}"
    end

    private

    def combine_exclude
      new_array = @exclude_paths << @user_excludes
      new_array.flatten! * ','
    end
  end
end
