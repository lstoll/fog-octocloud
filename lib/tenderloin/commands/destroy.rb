module Tenderloin
  class CLI < Clamp::Command
    subcommand "destroy", "destroy the environment" do
      def execute
        load_env!
        if Env.persisted_vm && vm = Env.compute.servers.get(Env.persisted_vm)
          logger.info "Destroying VM..."
          vm.stop if vm.running?
          vm.destroy
        else
          logger.error "No VM defined"
        end
      end
    end
  end
end
