module Fog
  module Compute
    class Octocloud
      class Real

        def update_cube(id, opts = {})
          request(:method => :put, :expects => [200], :body => opts, :path => "/api/cubes/#{id}" )
        end

      end
    end
  end
end
