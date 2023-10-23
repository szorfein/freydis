# frozen_string_literal: true

require 'mods/exec'

module Freydis
  class Rsync
    include Exec

    def initialize
      @workdir = '/mnt/freydis/backup'
      @exclude_paths = %w[
        "/dev/*"
        "/proc/*"
        "/sys/*"
        "/tmp/*"
        "/run/*"
        "/mnt/*"
        "/media/*"
        "/var/lib/dhcpcd/*"
        "*/.gvfs"
        "*/.vim/*"
        "*/.weechat/*"
        "*/.thumbnails/*"
        "*/.oh-my-zsh/*"
        "*/.cache/*"
        "*/.emacs.d/*"
        "*/.local/share/*"
        "*/.Xauthority"
        "*/.xsession-errors"
        "*/.quickemu/*"
        "*/.config/BraveSoftware/*"
        "*/.config/Min/*"
        "*/.config/emacs"
        "*/build/*"
        "*/tmp/*"
        "*/.npm"
        "*/.history"
        "*lost+found"
      ]
      #@opts = '-aAXHvR'
      @opts = '-aAXHv --relative'
      #@opts = '-aAXHvRx'
    end

    def backup
      DiskLuks.open
      mkdir @workdir
      exil = @exclude_paths * ','
      save = OPTIONS[:backup_paths] * ' '
      @opts += ' --delete'
      x "rsync #{@opts} --exclude={#{exil}} #{save} #{@workdir}"
      puts "Saved path #{save}"
      DiskLuks.close
    end

    def restore
      DiskLuks.open
      x "rsync #{@opts} #{@workdir} /"
      DiskLuks.close
    end
  end
end
