module Fog
  module Compute
    class Tenderfusion
      class Real

        def delete_vm(vmx)
          vmrun 'deleteVM', :vmx => vmx
        end

      end
    end
  end
end
