# frozen_string_literal: true

module Exec
  def x(command)
    sudo = Process.uid != 0 ? 'sudo' : ''
    unless system("#{sudo} #{command}")
      Msg.error "Execute: #{command}"
    end
  end
end
