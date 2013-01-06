require 'fog/core/model'

module Fog
  module Compute
    class Tenderfusion

      class Cube < Fog::Model

        identity :name

        attribute :source


        def save
          connection.import_box(name, source)
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
