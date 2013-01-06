require 'fog/core/model'

module Fog
  module Compute
    class Tenderfusion

      class Cube < Fog::Model

        identity :name

        def save
          raise "Can't save a Tenderloin cube"
        end

        def destroy
          requires :name
          connection.delete_box(name)
          true
        end

      end

    end
  end
end
