module Freydis
  module Guard
    def self.disk?(name)
      raise ArgumentError, "Bad name #{name}, should match with sdX" if !name.match(/^sd[a-z]{1}$/)
      raise ArgumentError, "No disk /dev/#{name}" if !File.exist? "/dev/#{name}"
      true
    end
  end
end
