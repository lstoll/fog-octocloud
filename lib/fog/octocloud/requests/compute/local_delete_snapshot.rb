module Fog
  module Compute
    class Octocloud
      class Real

        def local_delete_snapshot(vmname, snapname)
          vmx = vmx_for_vm(vmname)
          res = vmrun 'deleteSnapshot', :vmx => vmx, :opts => "'#{snapname}'"
        end

      end

      class Mock

        def local_delete_snapshot(vmname, snapname)
          raise "Server does not exist" unless data[:servers][vmname]
          raise "Snapshot does not exist" unless data[:servers][vmname][:snapshots].include?(snapname)
          data[:servers][vmname][:snapshots].delete(snapname)
        end

      end
    end
  end
end
