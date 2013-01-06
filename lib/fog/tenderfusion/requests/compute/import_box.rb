require 'open-uri'

module Fog
  module Compute
    class Tenderfusion
      class Real

        def import_box(boxname, src)
          target = box_dir.join(boxname)
          target.mkdir unless target.exist?
          input = Archive::Tar::Minitar::Input.new(open(src))
          input.each do |entry|
            input.extract_entry(target, entry)
          end

        end

      end
    end
  end
end
