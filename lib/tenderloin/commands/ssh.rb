require 'tenderloin/ssh'

module Tenderloin
  class CLI < Clamp::Command

    subcommand "ssh", "SSH in to the VM" do

      option ["--command", '-c'], "COMMAND", "command to run on the remote host"

      def execute
        load_env!
        if Env.persisted_vm && vm = Env.compute.servers.get(Env.persisted_vm)
          if vm.running?
            # This is where we can actually do shit. Make sure the machine is SSHable
            # This check is too slow though.
            # vm.wait_for(30) { sshable? }
            SSH.connect(vm.ip, command)
          else
            logger.info "VM Not running"
          end
        else
          logger.error "No VM defined"
        end
      end
    end
  end
end
