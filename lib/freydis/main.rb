# frozen_string_literal: true
# lib/main.rb

module Freydis
  class Main
    # Code here
    def initialize(args)
      Options.new(args[:argv])
    end

    def start
      DiskLuks.encrypt if ACTIONS[:encrypt]
      DiskLuks.open if ACTIONS[:open]
      DiskLuks.close if ACTIONS[:close]
      Rsync.new.backup if ACTIONS[:backup]
      Rsync.new.restore if ACTIONS[:restore]
      Secrets.backup if ACTIONS[:secrets_backup]
      Secrets.restore if ACTIONS[:secrets_restore]
      Config.new.save if ACTIONS[:config_save]
    end

    def bye
      puts
      puts "Bye !"
      exit
    end
  end
end
