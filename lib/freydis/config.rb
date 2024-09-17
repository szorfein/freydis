# frozen_string_literal: true

require 'yaml'
require 'fileutils'
require 'pathname'
require 'mods/msg'

module Freydis
  # Loads/Save config variable from a yaml file
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
        exclude_paths: [],
        restore_at: '/'
      }
    end

    def save(opts)
      FileUtils.mkdir_p Pathname.new(@cpath).parent.to_s
      load_opts(opts)
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

    private

    def load_opts(args)
      @opts[:disk] = args[:disk] || ''
      @opts[:disk_is_encrypt] = args[:disk_is_encrypt] || false
      @opts[:gpg_recipient] = args[:gpg_recipient] || ''
      @opts[:backup_paths] = args[:backup_paths] || []
      @opts[:exclude_paths] = args[:exclude_paths] || []
      @opts[:restore_at] = args[:restore_at] || '/'
    end
  end
end
