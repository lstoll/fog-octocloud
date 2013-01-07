require 'fog/compute/models/server'

module Fog
  module Compute
    class Tenderfusion

      class Server < Fog::Compute::Server

        identity :name

        attribute :running
        attribute :ip
        attribute :cube

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

        def public_ip_address
          ip
        end

        # def initialize(attributes={})
          # super
        # end

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

        def sshable?
          ready? && !public_ip_address.nil? && !!Timeout::timeout(30) { ssh 'pwd' }
        rescue SystemCallError, Net::SSH::AuthenticationFailed, Timeout::Error
          false
        end


      end

    end
  end
end
