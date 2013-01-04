module Fog
  module Compute
    class Tenderloin
      class Real

        def get_vm(id)
          request(['jsondump', '-f', id], true).merge({:id => id})
        end

      end
    end
  end
end
