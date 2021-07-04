# lib/rsync.rb

module Freydis
  class Rsync
    def initialize(data)
      @data = data
      @mountpoint = '/mnt/freydis'
      @exclude_paths = [
        "/dev/*",
        "/proc/*",
        "/sys/*",
        "/tmp/*",
        "/run/*",
        "/mnt/*",
        "/media/*",
        "/home/*/.thumbnails/*",
        "/home/*/.cache/mozilla/*",
        "/home/*/.cache/chromium/*",
        "/home/*/.local/share/Trash/*",
        "/lost+found",
      ]
      @opts = "-aAXHvR"
    end

    def backup
      add_config
      exil = @exclude_paths * ","
      save = @data[:paths] * " "
      @opts += " --delete"
      exec("rsync #{@opts} --exclude={#{exil}} #{save} #{@mountpoint}")
    end

    def restore
      exil = @exclude_paths * ","
      exec("rsync #{@opts} --exclude={#{exil}} #{@mountpoint} /")
    end

    private

    def add_config
      if !@data[:paths].include?("#{ENV['HOME']}/.config/freydis")
        @data[:paths] << "#{ENV['HOME']}/.config/freydis"
      end
    end

    def exec(command)
      sudo = Process.uid != 0 ? 'sudo' : ''
      if !system("#{sudo} #{command}")
        raise StandardError, "[-] #{command}"
      end
    end
  end
end
