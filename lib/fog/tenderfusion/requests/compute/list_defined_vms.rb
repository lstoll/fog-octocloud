module Fog
  module Compute
    class Tenderfusion
      class Real

        def list_defined_vms()
          # Boxes are just dirs in the right path
          vms = vm_dir.chidren.select {|p| p.directory?}
          vms.map {|vm| vm.split[1]}
        end

      end
    end
  end
end
