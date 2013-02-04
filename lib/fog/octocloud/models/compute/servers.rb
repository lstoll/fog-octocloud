require 'fog/core/collection'
require 'fog/octocloud/models/compute/server'

module Fog
  module Compute
    class Octocloud

      class Servers < Fog::Collection

        # default to the base, set on load
        model Fog::Compute::Octocloud::Server

        def all()
          set_model
          if connection.local_mode
            load(connection.local_list_defined_vms())
          else
            load(connection.list_vms())
          end
        end

        def get(identifier)
          set_model
          data = nil

          if connection.local_mode && connection.list_defined_vms().include?(name)
            data = new({ :name => name,
                         :running => connection.vm_running(name),
                         :ip => connection.vm_ip(name)})
          else
            data = connection.lookup_vm(identifier)
          end

          if data.empty?
            nil
          else
            new(data)
          end
        end

        private

        def set_model
          if connection.local_mode
            model Fog::Compute::Octocloud::LocalServer
          else
            model Fog::Compute::Octocloud::RemoteServer
          end
        end

      end

    end
  end
end
