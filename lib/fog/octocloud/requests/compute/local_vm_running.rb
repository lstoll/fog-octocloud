module Fog
  module Compute
    class Octocloud
      class Real

        def local_vm_running(name)
          vmx = vmx_for_vm(name)
          vmrun "list | grep '#{vmx}'"
          $? == 0 ? true : false
        end

      end
    end
  end
end
