require 'fog/core/collection'
require 'fog/octocloud/models/compute/cube'

module Fog
  module Compute
    class Octocloud

      class Cubes < Fog::Collection

        model Fog::Compute::Octocloud::Cube

        def all()
          if service.local_mode
            load(service.local_list_boxes())
          else
            load(service.remote_list_cubes())
          end
        end

        def get(identifier)
          data = if service.local_mode
            cube_select = service.local_list_boxes().select {|i| i[:name] == identifier}
            cube_select.empty? ? {} : cube_select.first
          else
             begin
               service.remote_get_cube(Integer(identifier).to_s)
             rescue ArgumentError => e
               cube = service.remote_list_cubes.select {|i| i['name'] == identifier}.first
               if cube
                 service.remote_get_cube(cube["id"])
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
          if service.local_mode
            Fog::Compute::Octocloud::LocalCube
          else
            Fog::Compute::Octocloud::RemoteCube
          end
        end

      end

    end
  end
end
