module Fog
  module Compute
    class Octocloud
      class Real

        def local_vm_running(name)
          vmx = vmx_for_vm(name)
          running = vmrun "list"
          running.include? vmx.to_s
        end

      end
    end
  end
end
