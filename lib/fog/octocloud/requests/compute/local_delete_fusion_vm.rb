module Fog
  module Compute
    class Tenderfusion
      class Real

        def delete_fusion_vm(name)
          vmx = vmx_for_vm(name)
          vmrun 'deleteVM', :vmx => vmx
        end

      end
    end
  end
end