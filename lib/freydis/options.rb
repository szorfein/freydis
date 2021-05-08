require 'optparse'

module Freydis
  class Options
    attr_accessor :init, :backup, :restore, :encrypt

    def initialize(args)
      @init = false
      @backup = false
      @restore = false
      @encrypt = false
      parse(args)
    end

    private

    def parse(argv)
      OptionParser.new do |opts|
        opts.banner = "Usage: freydis.rb [options]"

        opts.on("-i", "--init", "Create a config file.") do
          @init = true
        end

        opts.on("-b", "--backup", "Perform a backup.") do
          @backup = true
        end

        opts.on("-r", "--restore", "Restore saved datas on your system.") do
          @restore = true
        end

        opts.on("-e", "--encrypt", "Encrypt your device.") do
          @encrypt = true
        end

        begin
          opts.parse!(argv)
        rescue OptionParser::ParseError => e
          STDERR.puts e.message, "\n", opts
        end
      end
    end
  end
end
