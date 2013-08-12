module Fog
  module Compute
    class Octocloud
      class Real

        def local_list_boxes()
          # Boxes are just dirs in the right path
          boxes = @box_dir.children.select {|p| p.directory?}

          # Reject box directories without MD5 file and WARN
          #
          # Sometimes an empty box directory is created while importing
          # a remote box/ova. This will prevent an exception from being
          # rised if we list boxes while a cube is being created.
          boxes.reject! do |b|
            if File.exist?(b.join('.md5'))
              false
            else
              Fog::Logger.warning "Box #{b} MD5 not found, skipping"
              true
            end
          end

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
