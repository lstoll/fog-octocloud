require 'fog/core/collection'
require 'fog/tenderloin/models/compute/server'

module Fog
  module Compute
    class Tenderloin

      class Servers < Fog::Collection

        model Fog::Compute::Tenderloin::Server

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
