require 'optparse'

module Freydis
  class Options
    attr_reader :options

    def initialize(args)
      @options = {}
      parse(args)
    end

    private

    def parse(argv)
      OptionParser.new do |opts|
        opts.banner = "Usage: freydis.rb [options]"

        opts.on("-i", "--init", "Create a config file.") do
          @options[:init] = true
        end

        opts.on("-b", "--backup", "Perform a backup.") do
          @options[:backup] = true
        end

        opts.on("-r", "--restore", "Restore saved datas on your system.") do
          @options[:restore] = true
        end

        opts.on("-e", "--encrypt", "Encrypt your device.") do
          @options[:encrypt] = true
        end

        opts.on("-o", "--open", "Open and mount encrypted device at /mnt/freydis.") do
          @options[:open] = true
        end

        opts.on("-c", "--close", "Umount & close encrypted device.") do
          @options[:close] = true
        end

        opts.on("-dNAME", "--disk NAME", "To use the disk NAME (e.g: sda, sdb).") do |disk|
          @options[:disk] = disk if Freydis::Guard.disk? disk
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
