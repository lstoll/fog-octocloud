module Fog
  module Compute
    class Octocloud
      class Real

        def remote_export_vm(id, cube)
          remote_request(
            :method => :post,
            :expects => [202],
            :body => {:cube => cube},
            :path => "/api/virtual-machines/#{id}/export"
          )
        end

      end
    end
  end
end
