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
      @opts = "-aAXHv --delete"
    end

    def backup
      add_config
      exil = @exclude_paths * ","
      save = @data.options[:paths] * " "
      exec("rsync #{@opts} --exclude={#{exil}} #{save} #{@mountpoint}")
    end

    private

    def add_config
      if !@data.options[:paths].include?("#{ENV['HOME']}/.config/freydis")
        @data.options[:paths] << "#{ENV['HOME']}/.config/freydis"
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
