module Fog
  module Compute
    class Octocloud
      class Real

        def get_cube(id)
          request(:method => :get, :expects => [200], :path => "/api/cubes/#{id}" )
        end

      end
    end
  end
end
