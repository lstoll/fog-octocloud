module Fog
  module Compute
    class Octocloud
      class Real

        def remote_create_vm(opts = {})
          %w{type cube memory}.each do |opt|
            unless opts.include?(opt) || opts.include?(opt.to_sym)
              raise ArgumentError.new("type, template and memory are required options to create a VM")
            end
          end

          request(:method => :post, :expects => [200], :body => opts, :path => "/api/virtual-machines" )
        end

      end
    end
  end
end
