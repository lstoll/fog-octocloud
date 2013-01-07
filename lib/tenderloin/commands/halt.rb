module Tenderloin
  class CLI < Clamp::Command
    subcommand "halt", "stop the VM" do
      def execute
        load_env!
        if Env.persisted_vm && vm = Env.compute.servers.get(Env.persisted_vm)
          if vm.running?
            logger.info "Halting VM..."
            vm.stop
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
