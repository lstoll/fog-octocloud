module Fog
  module Compute
    class Tenderloin
      class Real

        def stop_vm(id)
          request(['halt', '-f', id])
        end

      end
    end
  end
end
