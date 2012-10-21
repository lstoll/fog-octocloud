module Fog
  module Compute
    class Octocloud
      class Real

        def delete_template(id)
          request(:method => :delete, :expects => [204], :path => "/api/templates/#{id}" )
        end

      end
    end
  end
end
