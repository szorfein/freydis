# lib/init.rb

module Freydis
  module Init
    def self.run(options)
      loop do
        puts %q{Please select an option:

  1. Choose a disk (plug on)
  2. Add more paths
  3. Reset paths
  4. Show options
  5. Save & Quit}

        print "\n> "
        case gets.chomp
        when '1'
          select_disk(options)
        when '2'
          puts "Add a path..."
          add_path(options)
        when '3'
          puts "Reseting paths..."
          options[:paths] = []
        when '4'
          show_options(options)
        else
          return
        end
      end
    end

    private

    def self.select_disk(options)
      disks_list = Dir.glob("/dev/sd?")
      puts "Available disks: (only type sdX)"
      disks_list.each { |d|
        your_disk = Freydis::Disk.new(d)
        puts "+ " + your_disk.complete_info
      }
      print "> "
      answer = $stdin.gets
      disk = answer.chomp
      if disk != ''
        options[:disk] = Freydis::Guard::disk(disk)
        puts "Disk #{disk} added."
      else
        puts "No disk added."
      end
    end

    def self.add_path(options)
      print "> "
      answer = $stdin.gets
      new_path = answer.chomp if answer
      if Dir.exists? new_path
        options[:paths] << new_path
        puts "Path '#{new_path}' added"
        display_path(options)
      else
        puts "[-] Path no found."
      end
    end

    def self.display_path(options)
      puts "Current paths:"
      options[:paths].each { |p| puts "+ #{p}" }
    end

    def self.show_options(options)
      puts options
    end
  end
end
