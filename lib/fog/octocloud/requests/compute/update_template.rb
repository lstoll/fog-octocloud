module Fog
  module Compute
    class Octocloud
      class Real

        def update_template(id, opts = {})
          request(:method => :put, :expects => [200], :body => opts, :path => "/api/templates/#{id}" )
        end

      end
    end
  end
end
