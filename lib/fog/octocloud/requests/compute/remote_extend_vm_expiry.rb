module Fog
  module Compute
    class Octocloud

      class Mock
        def remote_extend_vm_expiry(id, period)
          Fog::Mock.not_implemented
        end
      end

      class Real

        def remote_extend_vm_expiry(id, period)
          puts id
          remote_request(
            :method => :post,
            :expects => [204],
            :body => { :period => period },
            :path => "/api/virtual-machines/#{id}/extend"
          )
        end

      end
    end
  end
end
