module Tenderloin
  class CLI < Clamp::Command
    subcommand "up", "start the environment" do
      def execute
        load_env!
        if Env.persisted_vm && vm = Env.compute.servers.get(Env.persisted_vm)
          logger.info "VM already created. Starting VM if its not already running..."
          vm.start unless vm.running?
        else
          logger.info "Creating VM"
          svr = Env.compute.servers.create(:name => 'lointest', :cube => config.vm.box)
          logger.info "Waiting for VM to be ready"
          svr.wait_for { print "."; ready? }
          print "\n"
          logger.info "VM Created and running on: #{svr.ip}"
        end
      end
    end
  end
end
