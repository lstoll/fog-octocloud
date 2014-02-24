module Fog
  module Compute
    class Octocloud
      class Mock
        def remote_create_vm(opts)
          newid = rand(99999)
          opts.merge!({:private_ip_address => '127.0.0.1', :state => 'up'})
          data[:servers][newid] = opts
          opts.merge({:id => newid})
        end
      end

      class Real

        def remote_create_vm(opts = {})
          %w{type cube memory}.each do |opt|
            unless opts.include?(opt) || opts.include?(opt.to_sym)
              raise ArgumentError.new("type, template and memory are required options to create a VM")
            end
          end

          remote_request(:method => :post, :expects => [201], :body => opts, :path => "/api/virtual-machines" )
        end

      end
    end
  end
end
