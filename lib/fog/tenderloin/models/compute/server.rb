require 'fog/compute/models/server'

module Fog
  module Compute
    class Tenderloin

      class Server < Fog::Compute::Server

        identity :id

        attribute :running, :aliases => 'vm.running'
        attribute :ip, :aliases => 'vm.ip'
        attribute :private_key, :aliases => 'config.ssh.key'
        attribute :port, :aliases => 'config.ssh.port'
        attribute :username, :aliases => 'config.ssh.username'
        attribute :password, :aliases => 'config.ssh.password'


        def ssh(commands, options={}, &blk)
          require 'net/ssh'
          options[:password] = password
          super(commands, options)
        end

        def ready?
          running && ip
        end

        def running?
          running
        end

        def public_ip_address
          ip
        end

        def initialize(attributes={})
          super
        end

        def save
          raise "Save not implemented"
        end

        def destroy
          requires :id
          connection.destroy_vm(id)
          true
        end

        def start
          requires :id
          connection.start_vm(id)
          true
        end

        def stop
          requires :id
          connection.stop_vm(id)
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
