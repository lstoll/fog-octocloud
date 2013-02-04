module Fog
  module Compute
    class Octocloud
      class Real

        def remote_list_cubes()
          request(:method => :get, :expects => [200], :path => "/api/cubes" )
        end

      end
    end
  end
end
