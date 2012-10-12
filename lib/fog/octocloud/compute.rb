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

        def request(method, url, json_params, options)
          # convert params to strings for sort
          req_params = params.merge('apiKey' => @ninefold_compute_key, 'command' => command)
          req = URI.escape(req_params.sort_by{|k,v| k.to_s }.collect{|e| "#{e[0].to_s}=#{e[1].to_s}"}.join('&'))
          encoded_signature = url_escape(encode_signature(req))

          options = {
            :expects => 200,
            :method => 'GET',
            :query => "#{req}&signature=#{encoded_signature}"
          }.merge(options)

          begin
            response = @connection.request(options)
          end
          unless response.body.empty?
            # Because the response is some weird xml-json thing, we need to try and mung
            # the values out with a prefix, and if there is an empty data entry return an
            # empty version of the expected type (if provided)
            response = Fog::JSON.decode(response.body)
            if options.has_key? :response_prefix
              keys = options[:response_prefix].split('/')
              keys.each do |k|
                if response[k]
                  response = response[k]
                elsif options[:response_type]
                  response = options[:response_type].new
                  break
                else
                end
              end
              response
            else
              response
            end
          end
        end

      private
        def url_escape(string)
          string.gsub(/([^ a-zA-Z0-9_.-]+)/n) do
            '%' + $1.unpack('H2' * $1.size).join('%').upcase
          end.tr(' ', '+')
        end

        def encode_signature(data)
          Base64.encode64(OpenSSL::HMAC.digest('sha1', @ninefold_compute_secret, URI.encode(data.downcase).gsub('+', '%20'))).chomp
        end
      end
    end
  end
end
