require 'fog/core/model'

module Fog
  module Compute
    class Octocloud

      class Server < Fog::Model

        identity :id

        attribute :memory
        attribute :name
        attribute :message
        attribute :expiry
        attribute :cube
        attribute :mac
        attribute :type, :aliases => :hypervisor_type
        attribute :hypervisor_host
        attribute :template
        attribute :running
        attribute :ip

        def running?
          running
        end

        def initialize(attributes={})
          super
        end

        def save
          requires :memory, :type, :cube

          data = connection.create_vm(attributes)

          merge_attributes(data)
          true
        end

        def destroy
          requires :id
          connection.delete_vm(id)
          true
        end


      end

    end
  end
end
