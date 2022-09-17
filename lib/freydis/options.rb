require 'optparse'

module Freydis
  class Options
    def initialize(args)
      data = Data.new(data_file)
      data.load!

      @options = data.options
      parse(args)
    end

    private

    def parse(argv)
      OptionParser.new do |opts|
        opts.banner = "Usage: freydis.rb [options]"
        opts.version = VERSION

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

        opts.on("-d NAME", "--disk NAME", /^sd[a-z]$/, "To use the disk NAME (e.g: sda, sdb).") do |disk|
          @options[:disk] = Freydis::Guard.disk(disk)
        end

        opts.on("-L", "--path-list", "List all paths from your list.") do
          puts
          puts @options[:paths]
          exit
        end

        opts.on("-p PATH", "--path-add PATH", String, "Add absolute path PATH to the backup list") do |p|
          Freydis::Guard.path? p
          @options[:paths] << p if !@options[:paths].include? p
        end

        opts.on("-d PATH", "--path-del PATH", String, "Remove absolute path PATH from the backup list.") do |p|
          Freydis::Guard.path? p
          @options[:paths].delete p if @options[:paths].include? p
        end

        opts.on("-s", "--save", "Save currents arguments in a config file.") do
          @options[:save] = true
        end

        begin
          opts.parse!(argv)
        rescue OptionParser::ParseError => e
          warn e.message, "\n", opts
          exit 1
        end
      end
    end
  end
end
