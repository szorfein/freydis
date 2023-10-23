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
      Freydis::DiskLuks.open
      mkdir @workdir
      exil = @exclude_paths * ','
      save = CONFIG.paths * ' '
      @opts += ' --delete'
      x "rsync #{@opts} --exclude={#{exil}} #{save} #{@workdir}"
      puts "Saved path #{save}"
      Freydis::DiskLuks.close
    end

    def restore
      Freydis::DiskLuks.open
      x "rsync #{@opts} #{@workdir} /"
      Freydis::DiskLuks.close
    end
  end
end
