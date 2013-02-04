module Fog
  module Compute
    class Tenderfusion
      class Real

        def local_delete_box(boxname)
          target = @box_dir.join(boxname)
          target.rmtree
        end

      end
    end
  end
end
