require 'fog/compute/models/server'

module Fog
  module Compute
    class Octocloud

      class Server < Fog::Compute::Server

        def self.setup_default_attributes
          identity :id

          attribute :name
          attribute :running
          attribute :public_ip_address
          attribute :cube
          attribute :private_key_file
        end


        # def ssh(commands, options={}, &blk)
        #   require 'net/ssh'
        #   options[:password] = password
        #   super(commands, options)
        # end

        def listening_for_ssh?
          listening_on?(22)
        end

        def listening_on?(port)
          # Make sure we are working with the latest data
          reload unless public_ip_address
          return false unless public_ip_address
          begin
            Timeout::timeout(1) do
              begin
                s = TCPSocket.new(public_ip_address, port)
                s.close
                return true
              rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
                return false
              end
            end
          rescue Timeout::Error
          end

          return false
        end

        def ready?
          reload
          running && ip
        end

        def running?
          running
        end

        def ip
          public_ip_address
        end

        def private_key
          if private_key_file
            file = Pathname(private_key_file)
            file.read if file.exist?
          else
            @attributes[:private_key]
          end
        end


        def sshable?
          ready? && !public_ip_address.nil? && !!Timeout::timeout(30) { ssh 'pwd' }
        rescue SystemCallError, Net::SSH::AuthenticationFailed, Timeout::Error
          false
        end

        def run(script, run_dir = Pathname.new('/tmp'), &block)
          script = Pathname(script)
          path   = run_dir.join(script.basename)

          path_string = path.to_s

          scp(script.to_s, path_string)
          ssh("chmod +x #{path_string}")
          ssh(path_string, &block)
        end

        def fix_key_permissions!
          private_key_file.chmod(0600)
        end

        def shell
          fix_key_permissions!

          command = %w[ssh]
          command << '-i' << private_key_file.realpath.to_s
          command << '-o' << 'UserKnownHostsFile=/dev/null'
          command << '-o' << 'StrictHostKeyChecking=no'
          command << '-p' << '22'
          command << "#{username}@#{public_ip_address}"

          system(*command)
        end

        # Extend server expiry to period
        #
        # @example
        #     octoc = Fog::Compute.new( :provider => 'octocloud',
        #                               :octocloud_api_key => 'secret',
        #                               :octocloud_url => 'https://octocloud.dev')
        #     server = octoc.servers.find { |s| s.name == 'my-server' }
        #     # Extend expiry time 24 hours
        #     server.extend_expiry '24 hours'
        #
        # Sample period strings accepted:
        #
        # 24 hours
        # 13 minutes
        # 3 days
        def extend_expiry(period)
          requires :id
          # Ignore when using Fusion driver
          if service.local_mode
            false
          else
            service.remote_extend_vm_expiry(id, period)
            true
          end
        end

      end

      class LocalServer < Server
        setup_default_attributes

        attribute :network_type

        def enable_shared_folders
          service.local_enable_shared_folders(identity)
        end

        def share_folder(name, source)
          service.local_share_folder(identity, name, source)
        end

        def destroy
          requires :identity
          stop
          service.local_delete_fusion_vm(identity)
          begin
            service.local_delete_vm_files(identity)
          rescue Errno::ENOENT => e
            #ignore, vmware has already deleted it
          end
          true
        end

        def start
          requires :identity
          service.local_start_vm(identity)
          true
        end

        def stop
          requires :identity
          service.local_stop_vm(identity)
          true
        end

        # Public: Take a snapshot of the virtual machine
        # This will operate regardless of if the VM is running or not. If it is
        # running the contents of memory will need to be dumped to disk, this
        # may take some time.
        #
        # name - the name used to refer to the snapshot
        def snapshot(name)
          service.local_snapshot(id, name)
        end

        # Public: Lists all snapshots on this virtual machine
        def snapshots()
          service.local_list_snapshots(id)
        end

        # Public: Deletes the given snapshot
        #
        # name - name of the snapshot to delete
        def delete_snapshot(name)
          service.local_delete_snapshot(id, name)
        end

        # Public: Revert to the named snapshot
        #
        # name - name of the snapshot to revert to
        def revert_to_snapshot(name)
          service.local_revert_to_snapshot(id, name)
        end


        def save
          requires :cube

          conn_type = self.network_type || "nat"

          cube_str = cube.kind_of?(Cube) ? cube.identity : cube

          new_id = if @attributes[:id] == nil
                     "octocloud-#{cube_str}-#{Time.now.strftime("%Y%m%d%H%M%S")}"
                   else
                     @attributes[:id]
                   end


          service.local_create_vm(cube_str, new_id)

          service.local_edit_vmx(new_id, {"ethernet0.connectionType" => conn_type})

          service.local_start_vm(new_id)

          merge_attributes({:running => service.local_vm_running(new_id),
                             :cube => cube_str,
                             :id => new_id})
        end
      end

      class RemoteServer < Server

        setup_default_attributes

        attribute :memory
        attribute :message
        attribute :expiry
        # attribute :cube
        attribute :mac
        attribute :type, :aliases => :hypervisor_type
        attribute :hypervisor_host
        attribute :template
        # attribute :running
        attribute :state
        attribute :ip
        attribute :cpus
        attribute :created_at
        attribute :meta

        def running?
          running
        end

        def ready?
          (state == "up") && ip
        end

        def public_ip_address
          ip
        end

        def start
          # noop this, only really valid for local
          true
        end


        # def initialize(attributes={})
          # super
        # end

        def save
          requires :memory, :type, :cube

          attributes[:cube] = cube.kind_of?(Cube) ? cube.name : cube
          attributes[:memory] = memory.to_i

          data = service.remote_create_vm(attributes)

          merge_attributes(data)
          true
        end

        def running
          state == "up"
        end

        def destroy
          requires :id
          service.remote_delete_vm(id)
          true
        end

      end

    end
  end
end
