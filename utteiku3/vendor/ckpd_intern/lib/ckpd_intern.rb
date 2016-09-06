require "ckpd_intern/engine"

module CkpdIntern
  def root
    Pathname.new(File.dirname(__FILE__) + '/../')
  end

  module_function :root
end
