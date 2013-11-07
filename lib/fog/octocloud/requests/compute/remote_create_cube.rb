module Fog
  module Compute
    class Octocloud
      class Real

        def remote_create_cube(name, opts = {})
          remote_request(
            :method => :post,
            :expects => [200],
            :body => opts.merge(:name => name),
            :path => "/api/cubes"
          )
        end

      end
    end
  end
end
