module Fog
  module Compute
    class Octocloud
      class Real

        def delete_cube(id)
          request(:method => :delete, :expects => [204], :path => "/api/cubes/#{id}" )
        end

      end
    end
  end
end
