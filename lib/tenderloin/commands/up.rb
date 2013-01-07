module Tenderloin
  class CLI < Clamp::Command
    subcommand "up", "start the environment" do
      def execute
        load_env!
        if Env.persisted_vm && vm = Env.compute.servers.get(Env.persisted_vm)
          logger.info "VM already created. Starting VM if its not already running..."
          vm.start unless vm.running?
        elsif !Env.compute.cubes.get(config.vm.box)
          logger.error "No cube called #{config.vm.box} found."
        else
          # Calculate a resonable name. Where's my threading macro?
          name = split_all(File.join(Env.root_path, $ROOTFILE_NAME))[1..-1]
          name = name.map {|i| i.gsub('.', '_')}
          name = name[-2..-1]
          name << (0...5).map{65.+(rand(26)).chr}.join
          name = name.join('-')

          # Actually create the vm.
          logger.info "Creating VM"
          svr = Env.compute.servers.create(:name => name, :cube => config.vm.box)
          logger.info "Persisting the VM ID (#{name})..."
          Env.persist_vm(name)
          logger.info "Waiting for VM to be ready"
          svr.wait_for { print "."; ready? }
          print "\n"
          logger.info "VM Created and running on: #{svr.ip}"
        end
      end
    end
  end
end
