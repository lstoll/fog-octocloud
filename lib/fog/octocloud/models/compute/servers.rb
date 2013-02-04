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
            load(connection.local_list_defined_vms().map {|i| {:name => i}})
          else
            load(connection.list_vms())
          end
        end

        def get(identifier)
          data = nil

          if connection.local_mode && connection.local_list_defined_vms().include?(identifier)
            data = { :name => identifier,
                     :running => connection.local_vm_running(identifier),
                     :public_ip_address => connection.local_vm_ip(identifier)}
          else
            data = connection.lookup_vm(identifier)
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
