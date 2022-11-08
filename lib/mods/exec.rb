# frozen_string_literal: true

module Exec
  def x(command)
    sudo = Process.uid != 0 ? 'sudo' : ''
    cmd = "#{sudo} #{command}"
    unless system(cmd)
      warn "[-] Execute: #{cmd}"
      exit 1
    end
  end

  def mkdir(dir)
    if Process.uid == 0
      FileUtils.mkdir_p dir
    else
      x "mkdir -p #{dir}"
    end
  end

  def bsdtar(args)
    x "bsdtar #{args}"
  end

  def shred(*keys)
    keys_join = keys * ' '
    x "shred -u #{keys_join}"
  end
end
