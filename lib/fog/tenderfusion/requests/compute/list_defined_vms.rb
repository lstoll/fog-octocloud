module Fog
  module Compute
    class Tenderfusion
      class Real

        def list_defined_vms()
          # Boxes are just dirs in the right path
          boxdir = Pathname.new(File.join(@loin_dir, 'vmx'))
          boxdir.chidren.select {|p| p.directory?}
        end

      end
    end
  end
end
