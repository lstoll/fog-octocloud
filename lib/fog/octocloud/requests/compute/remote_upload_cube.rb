require 'fog/octocloud/requests/compute/convert_cube'

module Fog
  module Compute
    class Octocloud
      class Real

        def remote_upload_cube(id, file)
          # Get some VMDK action.
          upload = Pathname.new(file)
          dir = nil
          if upload.extname != '.vmdk'
            dir = Dir.mktmpdir
            import_file(Pathname.new(dir), upload)
            upload = Dir[File.join(dir, '*.vmdk')].first
          end
          remote_request(:method => :POST, :expects => [200], :path => "/api/cubes/#{id}.vmdk", :body => File.new(upload) )
          FileUtils.rm_rf(dir) if dir
        end

      end
    end
  end
end
