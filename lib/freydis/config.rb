# frozen_string_literal: true

require 'yaml'
require 'fileutils'
require 'pathname'
require 'mods/msg'

module Freydis
  class Config
    include Msg

    def initialize
      @cpath = ENV['XDG_CONFIG_HOME'] ?
                 "#{ENV['XDG_CONFIG_HOME']}/freydis/freydis.yaml" :
                 "#{ENV['HOME']}/.config/freydis/freydis.yaml"

    end

    def save
      FileUtils.mkdir_p Pathname.new(@cpath).parent.to_s
      File.write @cpath, YAML::dump(OPTIONS)
      success "Saving options to #{@cpath}..."
    end

    def load
      if File.exist? @cpath
        info 'Loading config...'
        data_load = YAML.load_file @cpath
        OPTIONS[:disk] = data_load[:disk]
        OPTIONS[:gpg_recipient] = data_load[:gpg_recipient]
        OPTIONS[:backup_paths] = data_load[:backup_paths]
      else
        info "Creating config file #{@cpath}..."
        save
      end
    end
  end
end
