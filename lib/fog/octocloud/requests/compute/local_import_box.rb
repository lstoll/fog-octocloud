require 'open-uri'
require 'archive/tar/minitar'
require 'tempfile'

require 'fog/octocloud/requests/compute/convert_cube'

module Fog
  module Compute
    class Octocloud
      class Real

        def local_import_box(boxname, src, md5, opts = {})
          target = @box_dir.join(boxname)
          target.mkdir unless target.exist?

          begin
            import_file(target, src, opts)
          rescue Exception => e
            target.rmtree
            raise e
          end

          File.open(target.join('.md5'), 'w') {|f| f.write(md5) }
        end


      end
    end
  end
end
