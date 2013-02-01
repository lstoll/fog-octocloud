module Fog
  module Compute
    class Octocloud
      class Real

        def lookup_vm(vmid)
          request(:method => :get, :expects => [200], :path => "/api/virtual-machines/#{vmid}" )
        end

      end
    end
  end
end
