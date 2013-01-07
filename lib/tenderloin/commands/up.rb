module Tenderloin
  class CLI < Clamp::Command
    subcommand "up", "start the environment" do
      def execute
        load_env!
        # Need to filter the cube by name, because our identity scheme is different
        cubes = Env.compute.cubes.all
        cube = cubes.index {|i| i.name = config.vm.box }
        cube = cubes[cube]
        if Env.persisted_vm && vm = Env.compute.servers.get(Env.persisted_vm)
          logger.info "VM already created. Starting VM if its not already running..."
          vm.start unless vm.running?
          wait_on_vm(vm)
        elsif !cube
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
          # TODO - options are slighty different for octocloud, need to pass memory here.

          svr = Env.compute.servers.create(:name => name, :cube => cube, :type => config.vm.type, :memory => config.vm.memory)
          logger.info "Persisting the VM ID (#{svr.identity})..."
          Env.persist_vm(svr.identity)
          wait_on_vm(svr)
        end
      end

      private

      def wait_on_vm(svr)
        logger.info "Waiting for VM to be ready"
        svr.wait_for { print "."; ready? }
        print "\n"
        logger.info "VM Created and running on: #{svr.ip}"
        share_folders(svr)
        provision_vm(svr)
      end

      def shared_folders
        shared_folders = [["tenderloin-root", Env.root_path, Tenderloin.config.vm.project_directory]]
        shared_folders = shared_folders + Tenderloin.config.shared_folders.folders

        # Basic filtering of shared folders. Basically only verifies that
        # the result is an array of 3 elements. In the future this should
        # also verify that the host path exists, the name is valid,
        # and that the guest path is valid.
        shared_folders.collect do |folder|
          if folder.is_a?(Array) && folder.length == 3
            folder
          else
            nil
          end
        end
      end

      def share_folders(vm)
        if Tenderloin.config.shared_folders.enabled
          logger.info "Creating shared folders metadata..."

          # Enable Shared Folders. It fails if it's already enabled.
          # If it's a real error the command to add a shared folder will fail,
          # so we can ignore this one.
          vm.enable_shared_folders

          shared_folders.each do |name, hostpath, guestpath|
            4.times do
              begin
                Timeout::timeout(10) {
                  vm.share_folder(name, File.expand_path(hostpath))
                  break
                }
              rescue Timeout::Error
                logger.warn "Sharing folder #{name} timed out"
              end
            end
          end

          logger.info "Linking shared folders..."

          Tenderloin::SSH.execute(vm.ip) do |ssh|
            shared_folders.each do |name, hostpath, guestpath|
              logger.info "-- #{name}: #{guestpath}"
              ssh.exec!("sudo bash -c 'if [ ! -d #{guestpath} ]; then mkdir #{guestpath} ; fi'")
              ssh.exec!("sudo ln -s /mnt/hgfs/#{name} #{guestpath}")
              ssh.exec!("sudo chown #{Tenderloin.config.ssh.username} #{guestpath}")
            end
          end
        end

      end
    end
  end
end
