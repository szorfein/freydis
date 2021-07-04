# lib/data.rb

require 'yaml'

module Freydis
  class Data
    attr_accessor :options

    def initialize(config_file, data = {})
      @config_file = config_file ||= "#{ENV['HOME']}/.config/freydis/freydis.yaml"
      @options = parse(data)
    end

    def parse(data)
      disk = data[:disk] ? data[:disk] : ""
      paths = data[:paths] ? data[:paths] : []
      opts = {
        :disk => disk,
        :paths => paths
      }
      opts
    end

    def load!
      if File.exist? @config_file
        datas = YAML.load_file @config_file
        @options.merge!(datas)
      else
        save
        STDERR.puts "Initialized config at #{@config_file}"
      end
    end

    def save
      conf_dir = "#{ENV['HOME']}/.config/freydis"
      Dir.mkdir conf_dir unless Dir.exist? conf_dir

      File.open(@config_file, 'w') { |f|
        YAML::dump(@options, f)
      }
    end
  end
end
