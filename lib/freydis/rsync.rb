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
      Freydis::DiskLuks.open
      mkdir @workdir
      exil = @exclude_paths * ','
      save = CONFIG.paths * ' '
      @opts += ' --delete'
      x "rsync #{@opts} --exclude={#{exil}} #{save} #{@workdir}"
      Freydis::DiskLuks.close
    end

    def restore
      Freydis::DiskLuks.open
      x "rsync #{@opts} #{@workdir} /"
      Freydis::DiskLuks.close
    end
  end
end
