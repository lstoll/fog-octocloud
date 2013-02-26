module Fog
  module Compute
    class Octocloud
      class Real

        def remote_update_cube(id, opts = {})
          remote_request(:method => :put, :expects => [200], :body => opts, :path => "/api/cubes/#{id}" )
        end

      end
    end
  end
end
