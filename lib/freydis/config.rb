# frozen_string_literal: true

require 'yaml'
require 'fileutils'
require 'pathname'

module Freydis
  class Config
    attr_accessor :gpg_recipient, :disk, :paths

    def initialize
      @cpath = "#{ENV['HOME']}/.config/freydis/freydis.yaml"
      @disk = nil
      @gpg_recipient = nil
      @paths = []
    end

    def load
      if File.exist? @cpath
        puts "Loading config..."
        data_load = YAML.load_file @cpath
        @disk = data_load[:disk]
        @gpg_recipient = data_load[:gpg_recipient]
        @paths = data_load[:paths]
      else
        puts "Creating config file #{@cpath}..."
        save
      end
    end

    def save
      FileUtils.mkdir_p Pathname.new(@cpath).parent.to_s
      File.write @cpath, YAML::dump({
        disk: @disk,
        gpg_recipient: @gpg_recipient,
        paths: @paths.uniq!
      })
      puts " ===> Saving options to #{@cpath}..."
    end
  end
end
