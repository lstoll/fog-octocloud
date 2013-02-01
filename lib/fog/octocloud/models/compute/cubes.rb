require 'fog/core/collection'
require 'fog/octocloud/models/compute/cube'

module Fog
  module Compute
    class Octocloud

      class Cubes < Fog::Collection

        model Fog::Compute::Octocloud::Cube

        def all()
          load(connection.list_cubes())
        end

        def get(identifier)
          data = connection.get_cube(identifier)
          if data.empty?
            nil
          else
            new(data)
          end
        end

      end

    end
  end
end
