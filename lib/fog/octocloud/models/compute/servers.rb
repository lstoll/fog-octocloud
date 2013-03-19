require 'fog/core/collection'
require 'fog/octocloud/models/compute/server'

module Fog
  module Compute
    class Octocloud

      class Servers < Fog::Collection

        # default to the base, set on load
        model Fog::Compute::Octocloud::Server

        def all()
          if service.local_mode
            load(service.local_list_defined_vms().map {|i| {:id => i}})
          else
            load(service.remote_list_vms())
          end
        end

        def get(identifier)
          data = nil

          if service.local_mode
            if service.local_list_defined_vms().include?(identifier)
              data = { :id => identifier,
                :running => service.local_vm_running(identifier),
                :public_ip_address => service.local_vm_ip(identifier)}
            end
          else
            data = service.remote_lookup_vm(identifier)
          end

          if data.nil? || data.empty?
            nil
          else
            new(data)
          end
        end

        # MAGIC SWITCH
        def model
          if service.local_mode
            Fog::Compute::Octocloud::LocalServer
          else
            Fog::Compute::Octocloud::RemoteServer
          end
        end

      end

    end
  end
end
