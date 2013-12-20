module Fog
  module Compute
    class Octocloud
      class Mock
        def remote_list_vms()
          data[:servers].values
        end
      end

      class Real

        def remote_list_vms()
          remote_request(:method => :get, :expects => [200], :path => "/api/virtual-machines" )
        end

      end
    end
  end
end
