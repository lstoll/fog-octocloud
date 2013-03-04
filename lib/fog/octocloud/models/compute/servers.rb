require 'fog/core/collection'
require 'fog/octocloud/models/compute/server'

module Fog
  module Compute
    class Octocloud

      class Servers < Fog::Collection

        # default to the base, set on load
        model Fog::Compute::Octocloud::Server

        def all()
          if connection.local_mode
            load(connection.local_list_defined_vms().map {|i| {:id => i}})
          else
            load(connection.remote_list_vms())
          end
        end

        def get(identifier)
          data = nil

          if connection.local_mode
            if connection.local_list_defined_vms().include?(identifier)
              data = { :id => identifier,
                :running => connection.local_vm_running(identifier),
                :public_ip_address => connection.local_vm_ip(identifier)}
            end
          else
            data = connection.remote_lookup_vm(identifier)
          end

          if data.nil? || data.empty?
            nil
          else
            new(data)
          end
        end

        # MAGIC SWITCH
        def model
          if connection.local_mode
            Fog::Compute::Octocloud::LocalServer
          else
            Fog::Compute::Octocloud::RemoteServer
          end
        end

      end

    end
  end
end
