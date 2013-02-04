module Fog
  module Compute
    class Octocloud
      class Real

        def delete_vm(vmid)
          request(:method => :delete, :expects => [204], :path => "/api/virtual-machines/#{vmid}" )
        end

      end
    end
  end
end
