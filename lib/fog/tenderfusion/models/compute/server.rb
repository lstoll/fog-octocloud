require 'fog/compute/models/server'

module Fog
  module Compute
    class Tenderfusion

      class Server < Fog::Compute::Server

        identity :name

        attribute :running
        attribute :public_ip_address
        attribute :cube
        attribute :private_key_file

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

        def enable_shared_folders
          connection.enable_shared_folders(identity)
        end

        def share_folder(name, source)
          connection.share_folder(identity, name, source)
        end

        def save
          requires :name, :cube

          cube_str = cube.kind_of?(Cube) ? cube.name : cube

          connection.create_vm(cube_str, name)

          connection.start_vm(name)

          merge_attributes({:running => connection.vm_running(name)})
        end

        def destroy
          requires :name
          stop
          connection.delete_fusion_vm(name)
          begin
            connection.delete_vm_files(name)
          rescue Errno::ENOENT => e
            #ignore, vmware has already deleted it
          end
          true
        end

        def start
          requires :name
          connection.start_vm(name)
          true
        end

        def stop
          requires :name
          connection.stop_vm(name)
          true
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
          command << '-p' << port.to_s
          command << "#{username}@localhost"

          system(*command)
        end

      end

    end
  end
end
