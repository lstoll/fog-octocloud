module Fog
  module Compute
    class Octocloud
      class Real

        def remote_delete_vm(vmid)
          remote_request(:method => :delete, :expects => [204], :path => "/api/virtual-machines/#{vmid}" )
        end

      end
    end
  end
end
