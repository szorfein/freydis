require 'optparse'

module Freydis
  class Options
    attr_accessor :init, :backup, :restore, :encrypt,
                  :open, :close,
                  :disk

    def initialize(args)
      @init = false
      @backup = false
      @restore = false
      @encrypt = false
      @open = false
      @close = false
      @disk = nil
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

        opts.on("-o", "--open", "Open and mount encrypted device at /mnt/freydis.") do
          @open = true
        end

        opts.on("-c", "--close", "Umount & close encrypted device.") do
          @close = true
        end

        opts.on("-dNAME", "--disk NAME", "To use the disk NAME (e.g: sda, sdb).") do |disk|
          @disk = disk if Freydis::Guard.disk? disk
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
