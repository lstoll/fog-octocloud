require 'tenderloin/ssh'

module Tenderloin
  class CLI < Clamp::Command

    subcommand "provision", "Provision the VM" do

      def execute
        load_env!
        if Env.persisted_vm && vm = Env.compute.servers.get(Env.persisted_vm)
          if vm.running?
            provision_vm vm
          else
            logger.info "VM Not running"
          end
        else
          logger.error "No VM defined"
        end
      end

    end

    def provision_vm(vm)
      run_rsync(vm) if Tenderloin.config.provisioning.rsync
      setup_script(vm) if Tenderloin.config.provisioning.script
      run_command(vm) if Tenderloin.config.provisioning.command
    end

    def run_rsync(vm)
      Tenderloin.config.provisioning.rsync.each do |rsync|
        logger.info "Running rsync for #{rsync.join(' -> ')}..."
        src, dst = *rsync
        SSH.execute(vm.ip) do |ssh|
          ssh.exec!("mkdir -p #{dst}")
        end
        puts SSH.rsync(vm.ip, File.expand_path(src), File.expand_path(dst))
      end
    end

    def setup_script(vm)
      logger.info "Uploading provisioning script..."

      SSH.upload!(vm.ip, StringIO.new(Tenderloin.config.provisioning.script), File.join('/tmp', "tenderloin_provision.sh"))

      Tenderloin.config.provisioning.command = "/tmp/tenderloin_provision.sh"
    end

    def run_command(vm)
      logger.info "Running Provisioning command..."
      cmd = ""
      cmd << "chmod +x /tmp/tenderloin_provision.sh && " if Tenderloin.config.provisioning.script
      cmd << Tenderloin.config.provisioning.command
      SSH.execute(vm.ip) do |ssh|
        ssh.exec!(cmd) do |channel, data, stream|
          # TODO: Very verbose. It would be easier to save the data and only show it during
          # an error, or when verbosity level is set high
          logger.info("#{stream}: #{data}")
        end
      end
    end

  end
end
