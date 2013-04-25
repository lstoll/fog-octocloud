module Fog
  module Compute
    class Octocloud
      class Real

        def local_snapshot(vmname, name)
          vmx = vmx_for_vm(vmname)
          vmrun 'snapshot', :opts => "'#{name}'", :vmx => vmx
        end

      end

      class Mock

        def local_snapshot(vmname, name)
          ''
        end

      end
    end
  end
end
