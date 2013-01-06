module Fog
  module Compute
    class Tenderfusion
      class Real

        def list_boxes()
          # Boxes are just dirs in the right path
          boxes = box_dir.chidren.select {|p| p.directory?}
          boxes.map {|b| b.split[1]}
        end

      end
    end
  end
end
