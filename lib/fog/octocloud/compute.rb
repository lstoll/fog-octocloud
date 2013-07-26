require 'fog/octocloud'
require 'fog/compute'
require 'base64'
require 'json'
require 'pathname'

require 'fog/octocloud/vmx_file'
require 'fog/octocloud/ovftool'

module Fog
  module Compute
    class Octocloud < Fog::Service
      recognizes :local_dir, :octocloud_api_key, :octocloud_url, :octocloud_user

      model_path 'fog/octocloud/models/compute'
      model       :server
      collection  :servers
      model       :cube
      collection  :cubes

      request_path 'fog/octocloud/requests/compute'

      ## local
      # fusion interaction
      request :local_vm_running
      request :local_start_vm
      request :local_stop_vm
      request :local_delete_fusion_vm
      request :local_vm_ip
      request :local_share_folder
      request :local_snapshot
      request :local_list_snapshots
      request :local_revert_to_snapshot
      request :local_delete_snapshot

      # filesystem interaction
      request :local_list_boxes
      request :local_list_defined_vms
      request :local_create_vm
      request :local_delete_vm_files
      request :local_delete_box
      request :local_import_box

      # vmx interaction
      request :local_edit_vmx

      ## remote
      request :remote_create_vm
      request :remote_list_vms
      request :remote_lookup_vm
      request :remote_delete_vm
      request :remote_create_cube
      request :remote_list_cubes
      request :remote_get_cube
      request :remote_update_cube
      request :remote_delete_cube
      request :remote_upload_cube


      class Mock

        attr_reader :local_mode, :data

        def initialize(options)
          # For now, just assume remote mode. It's the most likely to be mocked & tested
          @local_mode = false
          @data = {:servers => {}, :cubes => {}}
        end

        def request(options)
          raise "Not implemented"
        end
      end

      class Real

        attr_reader :local_mode
        attr_accessor :vmrunner

        def initialize(options)
          # local
          @local_dir = Pathname.new(options[:local_dir] || "~/.octocloud").expand_path
          @box_dir = @local_dir.join('boxes').expand_path
          @vm_dir = @local_dir.join('vms').expand_path
          @vmrunner = VMRun.new

          # remote
          begin
            @octocloud_url            = options[:octocloud_url] || Fog.credentials[:octocloud_url]
            @octocloud_api_key        = options[:octocloud_api_key] || Fog.credentials[:octocloud_api_key]
          rescue Fog::Errors::LoadError => e
            # ~/.fog may be empty or missing creds, probably fine
            # and we really want to use Fusion backend.
            #
            # @example
            #     octoc = Fog::Compute.new( :provider => 'octocloud' )
            #
            Fog::Logger.warning(
              "loading OctoCloud remote credentials failed, " +
              "resorting to local Fusion driver"
            )
          end

          @connection_options       = options[:connection_options] || {}
          @persistent               = options[:persistent] || false

          if options[:octocloud_user]
            @connection_options.merge!({:headers => {:"x-proxy-as" => options[:octocloud_user]}})
          end

          if @octocloud_url || @octocloud_api_key
            @local_mode = false
            @connection = Fog::Connection.new(@octocloud_url, @persistent, @connection_options)
          else
            @local_mode = true
            @local_dir.mkdir unless @local_dir.exist?
            @box_dir.mkdir unless @box_dir.exist?
            @vm_dir.mkdir unless @vm_dir.exist?
          end
        end

        def vmx_for_vm(name)
          @vm_dir.join(name, name + ".vmx")
        end

        def vmrun(cmd, args = {})
          @vmrunner.run(cmd, args)
        end

        def remote_request(options)

          login = Base64.urlsafe_encode64(@octocloud_api_key + ":")

          headers = options[:headers] || {}
          headers = {'Authorization' => "Basic #{login}"}.merge(headers)

          if options[:body].kind_of? Hash
            options[:body] = options[:body].to_json
            headers = {'Content-Type' => 'application/json'}.merge(headers)
          end

          options = {
            :expects => 200,
            :query => "",
            :headers => headers,
          }.merge(options)

          response = @connection.request(options)

          if response.body.empty?
            true
          else
            Fog::JSON.decode(response.body)
          end
        end

      end

      class VMRun
        VMRUN_COMMAND = "/Applications/VMware\\ Fusion.app/Contents/Library/vmrun"

        def run(cmd, args={})
          args[:vmx] = args[:vmx].to_s if args[:vmx].kind_of? Pathname
          runcmd = "#{VMRUN_COMMAND} #{cmd} #{args[:vmx]} #{args[:opts]}"
          retrycount = 0
          while true
            res = `#{runcmd}`
            if $? == 0
              return res
            elsif res =~ /The virtual machine is not powered on/
              return
            else
              if res =~ /VMware Tools are not running/
                sleep 1; next unless retrycount > 10
              end
              raise "Error running vmrun command:\n#{runcmd}\nResponse: " + res
            end
          end
        end

      end
    end
  end
end
