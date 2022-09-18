# frozen_string_literal: true

module Freydis
  class Rsync
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
      exec("rsync #{@opts} --exclude={#{exil}} #{save} #{@workdir}")
      close_disk
    end

    def restore
      open_disk
      exec("rsync #{@opts} #{@workdir} /")
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
        exec "mkdir -p #{@workdir}"
      end
    end

    private

    def exec(command)
      sudo = Process.uid != 0 ? 'sudo' : ''
      if !system("#{sudo} #{command}")
        Msg.error "Execute: #{command}"
      end
    end
  end
end
