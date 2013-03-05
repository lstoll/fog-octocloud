require 'fog/compute/models/server'

module Fog
  module Compute
    class Octocloud

      class Server < Fog::Compute::Server

        def self.setup_default_attributes
          identity :id

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

        def run(script, run_dir = Pathname.new('/tmp'))
          script = Pathname(script)
          path   = run_dir.join(script.basename)

          scp(script.to_s, path.to_s)
          ssh("chmod +x #{path}")
          ssh(path.to_s)
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
      end

      class LocalServer < Server
        setup_default_attributes

        def enable_shared_folders
          connection.local_enable_shared_folders(identity)
        end

        def share_folder(name, source)
          connection.local_share_folder(identity, name, source)
        end

        def destroy
          requires :identity
          stop
          connection.local_delete_fusion_vm(identity)
          begin
            connection.local_delete_vm_files(identity)
          rescue Errno::ENOENT => e
            #ignore, vmware has already deleted it
          end
          true
        end

        def start
          requires :identity
          connection.local_start_vm(identity)
          true
        end

        def stop
          requires :identity
          connection.local_stop_vm(identity)
          true
        end


        def save
          requires :cube

          cube_str = cube.kind_of?(Cube) ? cube.identity : cube

          new_id = if @attributes[:id] == nil
                     "octocloud-#{cube_str}-#{Time.now.strftime("%Y%m%d%H%M%S")}"
                   else
                     @attributes[:id]
                   end


          connection.local_create_vm(cube_str, new_id)

          connection.local_start_vm(new_id)

          merge_attributes({:running => connection.local_vm_running(new_id),
                             :cube => cube_str,
                             :id => new_id})
        end
      end

      class RemoteServer < Server

        setup_default_attributes

        attribute :memory
        attribute :name
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

          data = connection.remote_create_vm(attributes)

          merge_attributes(data)
          true
        end

        def destroy
          requires :id
          connection.remote_delete_vm(id)
          true
        end

      end

    end
  end
end
