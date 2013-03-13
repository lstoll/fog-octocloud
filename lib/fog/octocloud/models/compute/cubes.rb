require 'fog/core/collection'
require 'fog/octocloud/models/compute/cube'

module Fog
  module Compute
    class Octocloud

      class Cubes < Fog::Collection

        model Fog::Compute::Octocloud::Cube

        def all()
          if connection.local_mode
            load(connection.local_list_boxes())
          else
            load(connection.remote_list_cubes())
          end
        end

        def get(identifier)
          data = if connection.local_mode
            cube_select = connection.local_list_boxes().select {|i| i[:name] == identifier}
            cube_select.empty? ? {} : cube_select.first
          else
             begin
               connection.remote_get_cube(Integer(identifier).to_s)
             rescue ArgumentError => e
               cube = connection.remote_list_cubes.select {|i| i['name'] == identifier}.first
               if cube
                 connection.remote_get_cube(cube["id"])
               else
                 {}
               end
             rescue Excon::Errors::NotFound => nfe
               {}
             end
          end

          if data.empty?
            nil
          else
            new(data)
          end
        end

        # MAGIC SWITCH
        def model
          if connection.local_mode
            Fog::Compute::Octocloud::LocalCube
          else
            Fog::Compute::Octocloud::RemoteCube
          end
        end

      end

    end
  end
end
