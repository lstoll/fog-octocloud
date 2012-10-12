module Fog
  module Compute
    class Octocloud
      class Real

        def create_vm(opts = {})
          unless opts.include?('type') && opts.include?('template') && opts.include?('memory')
            raise ArgumentError.new("type, template and memory are required options to create a VM")
          end
          request(:method => :post, :expects => [200], :body => opts, :path => "/api/instances" )
        end

      end
    end
  end
end
