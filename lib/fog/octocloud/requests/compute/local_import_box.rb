require 'open-uri'
require 'archive/tar/minitar'
require 'tempfile'

module Fog
  module Compute
    class Octocloud
      class Real

        def local_import_box(boxname, src)
          target = @box_dir.join(boxname)
          target.mkdir unless target.exist?

          import_file(target, src)
        end


      end
    end
  end
end
