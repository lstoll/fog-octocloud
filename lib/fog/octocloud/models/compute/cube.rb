require 'fog/core/model'

module Fog
  module Compute
    class Octocloud

      class Cube < Fog::Model

        identity :id

        attribute :name
        attribute :url
        attribute :revision

        def save
          requires :name, :url

          attrs = {'name' => name, 'url' => url}
          if identity
            data = connection.update_cube(identity, attrs)
          else
            data = connection.create_cube(attrs)
          end
          merge_attributes(data)
          true
        end

        def destroy
          requires :id
          connection.delete_cube(id)
          true
        end


      end

    end
  end
end
