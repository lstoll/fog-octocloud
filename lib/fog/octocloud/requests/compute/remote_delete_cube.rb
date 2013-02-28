module Fog
  module Compute
    class Octocloud
      class Real

        def remote_delete_cube(id)
          remote_request(:method => :delete, :expects => [204], :path => "/api/cubes/#{id}" )
        end

      end
    end
  end
end
