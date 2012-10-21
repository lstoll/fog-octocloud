module Fog
  module Compute
    class Octocloud
      class Real

        def list_templates()
          request(:method => :get, :expects => [200], :path => "/api/templates" )
        end

      end
    end
  end
end
