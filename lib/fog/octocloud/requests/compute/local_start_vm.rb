module Fog
  module Compute
    class Octocloud
      class Real

        # is_vmware_running ? false : true is optimal, but won't delete.
        def local_start_vm(name, opts={ :headless => true })
          vmx = vmx_for_vm(name)
          gui_opt = opts[:headless] == true ? "nogui" : "gui"
          vmrun('start', :opts => gui_opt, :vmx => vmx)
        end

        private

        def is_vmware_running
          `ps aux | grep VMware`
          $? == 0
        end

      end
    end
  end
end
