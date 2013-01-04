module Fog
  module Compute
    class Tenderloin
      class Real

        def list_vms()
          Dir[@vm_glob]
        end

      end
    end
  end
end
