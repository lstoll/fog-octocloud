module Fog
  module Compute
    class Octocloud
      class Real

        def remote_create_cube(opts = {})
          unless opts.include?('name')
            raise ArgumentError.new("name are required options to create a Cube")
          end
          remote_request(:method => :post, :expects => [200], :body => opts, :path => "/api/cubes" )
        end

      end
    end
  end
end
