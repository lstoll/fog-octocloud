module Fog
  module Compute
    class Tenderfusion
      class Real

        def local_list_defined_vms()
          # VM names are the dirname
          vms = @vm_dir.children.select {|p| p.directory?}
          vms.map {|vm| vm.split[1].to_s}
        end

      end
    end
  end
end
