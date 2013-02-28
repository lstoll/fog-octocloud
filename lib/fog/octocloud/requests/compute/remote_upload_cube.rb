module Fog
  module Compute
    class Octocloud
      class Real

        def remote_upload_cube(id, file)
          remote_request(:method => :POST, :expects => [200], :path => "/api/cubes/#{id}.vmdk", :body => file )
        end

      end
    end
  end
end
