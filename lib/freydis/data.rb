# lib/data.rb

require 'yaml'

module Freydis
  class Data
    attr_accessor :options

    def initialize(data_file)
      @data_file = data_file
      @options = {
        :disk => "",
        :disk_id => "",
        :disk_uuid => "",
        :disk_partuuid => "",
        :paths => []
      }
    end

    def load!
      if File.exist? @data_file
        datas = YAML.load_file @data_file
        @options.merge!(datas)
      else
        save
        STDERR.puts "Initialized config at #{@data_file}"
      end
    end

    def save
      conf_dir = "#{ENV['HOME']}/.config/freydis"
      Dir.mkdir conf_dir unless Dir.exist? conf_dir

      File.open(@data_file, 'w') { |f|
        YAML::dump(@options, f)
      }
    end
  end
end
