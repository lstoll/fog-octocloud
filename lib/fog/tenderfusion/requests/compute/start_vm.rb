module Fog
  module Compute
    class Tenderfusion
      class Real

        def start_vm(id)
          request(['up', '-f', id])
        end

      end
    end
  end
end
