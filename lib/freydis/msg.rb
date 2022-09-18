
module Freydis
  module Msg
    module_function

    def info(msg)
      puts "> #{msg}"
    end

    def success(msg)
      puts " ===> #{msg}"
    end

    def error(msg)
      warn "[-] #{msg}"
      exit 1
    end
  end
end
