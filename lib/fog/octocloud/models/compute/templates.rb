require 'fog/core/collection'
require 'fog/octocloud/models/compute/template'

module Fog
  module Compute
    class Octocloud

      class Templates < Fog::Collection

        model Fog::Compute::Octocloud::Template

        def all()
          load(connection.list_templates())
        end

        def get(identifier)
          data = connection.get_template(identifier)
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
