require 'fog/core/collection'
require 'fog/tenderfusion/models/compute/cube'

module Fog
  module Compute
    class Tenderfusion

      class Cubes < Fog::Collection

        model Fog::Compute::Tenderfusion::Cube

        def all()
          load(connection.list_boxes().map {|i| {:name => i}})
        end

        def get(identifier)
          if connection.list_boxes().include?(identifier)
            new({:name => identifier})
          else
            nil
          end
        end

        def import(name, source)
          connection.import_box(name, source)
        end

      end

    end
  end
end
