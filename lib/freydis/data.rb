# lib/data.rb

require 'yaml'

module Freydis
  class Data
    attr_accessor :options

    def initialize
      @config_file = "#{ENV['HOME']}/.config/freydis/freydis.yaml"
      @options = {
        :disk => "",
        :disk_id => "",
        :disk_uuid => "",
        :disk_partuuid => "",
        :paths => []
      }
    end

    def load
      if File.exist? @config_file
        options_config = YAML.load_file @config_file
        @options.merge!(options_config)
      else
        save
        STDERR.puts "Initialized config at #{@config_file}"
      end
    end

    def save
      conf_dir = "#{ENV['HOME']}/.config/freydis"
      Dir.mkdir conf_dir if !Dir.exists? conf_dir

      File.open(@config_file, 'w') { |f|
        YAML::dump(@options, f)
      }
    end
  end
end
