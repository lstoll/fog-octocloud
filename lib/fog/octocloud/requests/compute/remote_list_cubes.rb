module Fog
  module Compute
    class Octocloud
      class Mock
        def remote_list_cubes()
          data[:cubes].values
        end
      end

      class Real

        def remote_list_cubes()
          remote_request(:method => :get, :expects => [200], :path => "/api/cubes" )
        end

      end
    end
  end
end
