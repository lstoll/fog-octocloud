require 'fog/tenderloin'
require 'fog/compute'
require 'base64'
require 'json'

module Fog
  module Compute
    class Tenderloin < Fog::Service

      recognizes :loin_cmd, :loinfile_glob

      model_path 'fog/tenderloin/models/compute'
      model       :server
      collection  :servers

      request_path 'fog/tenderloin/requests/compute'
      request :list_vms
      request :get_vm
      request :start_vm
      request :stop_vm
      request :destroy_vm

      class Mock

        def initialize(options)
        end

        def request(options)
          raise "Not implemented"
        end
      end

      class Real

        def initialize(options)
          @vm_glob     = options[:loinfile_glob] || "**/*.loin"
          @loin_cmd    = options[:loin_cmd]      || "loin"
        end

        def request(params, json_resp=false)
          params = params.join(" ") if params.kind_of? Array
          ret = `#{@loin_cmd} #{params}`

          raise "Error running command:\n#{ret}" if $? != 0

          if json_resp
            to_dotted_hash(Fog::JSON.decode(ret))
          else
            ret
          end
        end

        def to_dotted_hash(source, target = {}, namespace = nil)
          prefix = "#{namespace}." if namespace
          case source
          when Hash
            source.each do |key, value|
              to_dotted_hash(value, target, "#{prefix}#{key}")
            end
          when Array
            source.each_with_index do |value, index|
              to_dotted_hash(value, target, "#{prefix}#{index}")
            end
          else
            target[namespace] = source
          end
          target
        end


      end
    end
  end
end
