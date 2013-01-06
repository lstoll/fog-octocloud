module Fog
  module Compute
    class Tenderfusion
      class Real

        def list_vms()
          Dir[@vm_glob]
        end

      end
    end
  end
end
