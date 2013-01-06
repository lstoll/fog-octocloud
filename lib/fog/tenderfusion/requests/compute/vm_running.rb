module Fog
  module Compute
    class Tenderfusion
      class Real

        def vm_running(vmx)
          `#{VMRUN} list | grep "#{vmx}"`
          $? == 0 ? true : false
        end

      end
    end
  end
end
