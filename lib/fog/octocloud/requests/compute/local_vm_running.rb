module Fog
  module Compute
    class Tenderfusion
      class Real

        def local_vm_running(name)
          vmx = vmx_for_vm(name)
          `#{VMRUN} list | grep "#{vmx}"`
          $? == 0 ? true : false
        end

      end
    end
  end
end
