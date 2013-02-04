module Fog
  module Compute
    class Tenderfusion
      class Real

        def local_get_vm(id)
          request(['jsondump', '-f', id], true).merge({:id => id})
        end

      end
    end
  end
end
