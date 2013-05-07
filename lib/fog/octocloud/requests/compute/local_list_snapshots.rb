module Fog
  module Compute
    class Octocloud
      class Real

        def local_list_snapshots(vmname)
          vmx = vmx_for_vm(vmname)
          res = vmrun 'listSnapshots', :vmx => vmx
          res.split("\n")[1..-1]
        end

      end

      class Mock

        def local_list_snapshots(vmname)
          raise "Server does not exist" unless data[:servers][vmname]
          data[:servers][vmname][:snapshots] || []
        end

      end
    end
  end
end
