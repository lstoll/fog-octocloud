module Fog
  module Compute
    class Octocloud
      class Real

        def remote_lookup_vm(vmid)
          remote_request(:method => :get, :expects => [200], :path => "/api/virtual-machines/#{vmid}" )
        end

      end
    end
  end
end
