module Fog
  module Compute
    class Octocloud
      class Real

        def get_template(id)
          request(:method => :get, :expects => [200], :path => "/api/templates/#{id}" )
        end

      end
    end
  end
end
