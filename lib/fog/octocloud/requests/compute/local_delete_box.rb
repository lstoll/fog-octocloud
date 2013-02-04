module Fog
  module Compute
    class Tenderfusion
      class Real

        def delete_box(boxname)
          target = @box_dir.join(boxname)
          target.rmtree
        end

      end
    end
  end
end
