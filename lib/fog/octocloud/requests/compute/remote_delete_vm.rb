module Fog
  module Compute
    class Octocloud
      class Mock
        def remote_delete_vm(vmid)
          data[:servers].delete(vmid)
        end
      end

      class Real

        def remote_delete_vm(vmid)
          remote_request(:method => :delete, :expects => [202], :path => "/api/virtual-machines/#{vmid}" )
        end

      end
    end
  end
end
