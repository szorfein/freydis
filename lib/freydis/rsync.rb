# frozen_string_literal: true

require 'mods/exec'

module Freydis
  class Rsync
    include Exec

    def initialize
      @workdir = '/mnt/freydis/backup/'
      @exclude_paths = %w[
        /dev/*
        /proc/*
        /sys/*
        /tmp/*
        /run/*
        /mnt/*
        /media/*
        /var/lib/dhcpcd/*
        /home/*/.gvfs
        /home/*/.thumbnails/*
        /home/*/.cache/*
        /home/*/.local/share/*
        /home/*/.Xauthority
        /home/*/.xsession-errors
        /lost+found
      ]
      @opts = '-aAXHvRx'
    end

    def backup
      open_disk
      create_workdir
      exil = @exclude_paths * ','
      save = CONFIG.paths * ' '
      @opts += ' --delete'
      x "rsync #{@opts} --exclude={#{exil}} #{save} #{@workdir}"
      close_disk
    end

    def restore
      open_disk
      x "rsync #{@opts} #{@workdir} /"
      close_disk
    end

    protected

    def open_disk
      Freydis::DiskLuks.open
    end

    def close_disk
      Freydis::DiskLuks.close
    end

    def create_workdir
      if Process.uid == 0
        FileUtils.mkdir_p @workdir
      else
        x "mkdir -p #{@workdir}"
      end
    end
  end
end
