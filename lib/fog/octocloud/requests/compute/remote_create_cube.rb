module Fog
  module Compute
    class Octocloud
      class Mock
        def remote_create_cube(name, opts = {})
          data[:cubes][name] = opts.merge(:name => name)
          Fog::Compute::Octocloud::Cube.new(data[:cubes][name])
          data[:cubes][name]
        end
      end

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
