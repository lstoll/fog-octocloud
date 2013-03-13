module Fog
  module Compute
    class Octocloud
      class Real

        def local_list_boxes()
          # Boxes are just dirs in the right path
          boxes = @box_dir.children.select {|p| p.directory?}
          boxes.map do |b|
            {
              :name => b.split[1].to_s,
              :md5 => File.open(b.join('.md5')).read.strip
            }
          end
        end

      end
    end
  end
end
