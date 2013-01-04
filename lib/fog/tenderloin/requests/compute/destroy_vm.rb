module Fog
  module Compute
    class Tenderloin
      class Real

        def destroy_vm(id)
          request(['destroy', '-f', id])
        end

      end
    end
  end
end
