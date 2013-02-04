module Fog
  module Compute
    class Tenderfusion
      class Real

        def delete_vm_files(vmname)
          target = vm_dir.join(vmname)
          target.rmtree
        end

      end
    end
  end
end
