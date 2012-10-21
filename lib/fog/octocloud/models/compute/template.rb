require 'fog/core/model'

module Fog
  module Compute
    class Octocloud

      class Template < Fog::Model

        identity :id

        attribute :name
        attribute :image_urls, :aliases => 'image-urls'
        attribute :revision

        def save
          requires :name, :image_urls

          attrs = {'name' => name, 'image-urls' => image_urls}
          if identity
            data = connection.update_template(identity, attrs)
          else
            data = connection.create_template(attrs)
          end
          merge_attributes(data)
          true
        end

        def destroy
          requires :id
          connection.delete_template(id)
          true
        end


      end

    end
  end
end
