module Fog
  module Compute
    class Octocloud
      class Real

        def list_vms()
          request(:method => :get, :expects => [200], :path => "/api/virtual-machines" )
        end

      end
    end
  end
end
