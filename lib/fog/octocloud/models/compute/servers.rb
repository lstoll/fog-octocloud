require 'fog/core/collection'
require 'fog/octocloud/models/compute/server'

module Fog
  module Compute
    class Octocloud

      class Servers < Fog::Collection

        model Fog::Compute::Octocloud::Server

        def all()
          load(connection.list_vms())
        end

        def get(identifier)
          data = connection.lookup_vm(identifier)
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
