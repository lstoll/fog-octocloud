require 'fog/core/model'

module Fog
  module Compute
    class Octocloud

      class Cube < Fog::Model

        def self.setup_default_attributes

          identity :name

          attribute :source

          # These are the 'octocloud' ones. Get some commonality!
          # identity :id
          # attribute :url
          # attribute :revision
        end
      end

      class LocalCube < Cube
        setup_default_attributes

         def save
          connection.local_import_box(name, source)
        end

        def destroy
          requires :name
          connection.local_delete_box(name)
          true
        end
      end

      class RemoteCube < Cube
        setup_default_attributes

        def save
          requires :name, :url

          attrs = {'name' => name, 'url' => url}
          if identity
            data = connection.remote_update_cube(identity, attrs)
          else
            data = connection.remote_create_cube(attrs)
          end
          merge_attributes(data)
          true
        end

        def destroy
          requires :id
          connection.remote_delete_cube(id)
          true
        end

      end

    end
  end
end
