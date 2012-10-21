module Fog
  module Compute
    class Octocloud
      class Real

        def create_template(opts = {})
          unless opts.include?('name') && opts.include?('image-urls')
            raise ArgumentError.new("name and image-urls are required options to create a Template")
          end
          request(:method => :post, :expects => [200], :body => opts, :path => "/api/templates" )
        end

      end
    end
  end
end
