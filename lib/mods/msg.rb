# frozen_string_literal: true

module Msg
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
