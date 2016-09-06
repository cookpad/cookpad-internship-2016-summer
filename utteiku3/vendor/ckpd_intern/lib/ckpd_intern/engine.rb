module CkpdIntern
  class Engine < ::Rails::Engine
    isolate_namespace CkpdIntern

    config.assets.precompile += Dir.chdir(File.dirname(__FILE__) + '/../../app/assets/images') { Dir.glob('ckpd_intern/{item,category}/*.png') }
  end
end
