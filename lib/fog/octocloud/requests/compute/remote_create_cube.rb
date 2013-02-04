module Fog
  module Compute
    class Octocloud
      class Real

        def remote_create_cube(opts = {})
          unless opts.include?('name') && opts.include?('url')
            raise ArgumentError.new("name and url are required options to create a Cube")
          end
          request(:method => :post, :expects => [200], :body => opts, :path => "/api/cubes" )
        end

      end
    end
  end
end
