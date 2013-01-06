require 'fog/core/collection'
require 'fog/tenderfusion/models/compute/server'

module Fog
  module Compute
    class Tenderfusion

      class Servers < Fog::Collection

        model Fog::Compute::Tenderfusion::Server

        def all()
          load(connection.list_defined_vms().map {|i| {:name => i}})
        end

        def get(name)
          if connection.list_defined_vms().include?(name)
            new({ :name => name,
                  :running => connection.vm_running(name),
                  :ip => connection.vm_ip(name)})
          else
            nil
          end
        end

      end

    end
  end
end
