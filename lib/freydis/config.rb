# frozen_string_literal: true

require 'yaml'
require 'fileutils'
require 'pathname'
require 'mods/msg'

module Freydis
  class Config
    include Msg
    attr_reader :opts

    def initialize
      @cpath = ENV['XDG_CONFIG_HOME'] ?
                 "#{ENV['XDG_CONFIG_HOME']}/freydis/freydis.yaml" :
                 "#{ENV['HOME']}/.config/freydis/freydis.yaml"
      @opts = {
        disk: '',
        disk_is_encrypt: false,
        gpg_recipient: '',
        backup_paths: [],
        exclude_paths: []
      }
    end

    def save(opts)
      FileUtils.mkdir_p Pathname.new(@cpath).parent.to_s
      @opts[:disk] = opts[:disk] || ''
      @opts[:disk_is_encrypt] = opts[:disk_is_encrypt] || false
      @opts[:gpg_recipient] = opts[:gpg_recipient] || ''
      @opts[:backup_paths] = opts[:backup_paths] || []
      @opts[:exclude_paths] = opts[:exclude_paths] || []
      File.write @cpath, YAML.dump(@opts)
      success "Saving options to #{@cpath}..."
    end

    def load
      if File.exist? @cpath
        info 'Loading config...'
        @opts = YAML.load_file @cpath
      else
        info "Creating config file #{@cpath}..."
        save
      end
    end
  end
end
