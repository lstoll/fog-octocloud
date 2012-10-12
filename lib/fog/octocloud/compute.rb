require 'fog/octocloud'
require 'fog/compute'

module Fog
  module Compute
    class Octocloud < Fog::Service

      requires :octocloud_api_key, :octocloud_url

      # model_path 'fog/ninefold/models/compute'
      # model       :server
      # collection  :servers
      # model       :flavor
      # collection  :flavors
      # model       :image
      # collection  :images

      # request_path 'fog/ninefold/requests/compute'
      # General list-only stuff
      # request :list_accounts
      # request :list_events

      class Mock

        def initialize(options)
        end

        def request(options)
          raise "Not implemented"
        end
      end

      class Real

        def initialize(options)
          @octocloud_url            = options[:octocloud_url] || Fog.credentials[:octocloud_url]
          @octocloud_api_key        = options[:octocloud_api_key] || Fog.credentials[:octocloud_api_key]
          @connection_options       = options[:connection_options] || {}
          @persistent               = options[:persistent] || false
          @connection = Fog::Connection.new(@octocloud_url, @persistent, @connection_options)
        end

        def request(options)

          options = {
            :expects => 200,
            :query => ""
          }.merge(options)

          response = @connection.request(options)

          if response.body.empty?
            true
          else
            Fog::JSON.decode(response.body)
          end
        end

      end
    end
  end
end
