module Fog
  module Compute
    class Tenderloin
      class Real

        def start_vm(id)
          request(['up', '-f', id])
        end

      end
    end
  end
end
