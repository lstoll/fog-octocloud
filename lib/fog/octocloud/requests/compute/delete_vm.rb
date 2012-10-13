module Fog
  module Compute
    class Octocloud
      class Real

        def delete_vm(vmid)
          request(:method => :delete, :expects => [204], :path => "/api/instances/#{vmid}" )
        end

      end
    end
  end
end
