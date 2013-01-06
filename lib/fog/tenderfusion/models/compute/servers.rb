require 'fog/core/collection'
require 'fog/tenderfusion/models/compute/server'

module Fog
  module Compute
    class Tenderfusion

      class Servers < Fog::Collection

        model Fog::Compute::Tenderfusion::Server

        def all()
          vms = connection.list_vms().collect do |vm|
            connection.get_vm(vm)
          end
          load(vms)
        end

        def get(identifier)
          data = connection.get_vm(identifier)
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
