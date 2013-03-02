module Fog
  module Compute
    class Octocloud
      class Real

        def remote_get_cube(id)
          remote_request(:method => :get, :expects => [200], :path => "/api/cubes/#{id}" )
        end

      end
    end
  end
end
