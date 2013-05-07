module Fog
  module Compute
    class Octocloud
      class Real

        def local_revert_to_snapshot(vmname, snapname)
          vmx = vmx_for_vm(vmname)
          res = vmrun 'revertToSnapshot', :vmx => vmx, :opts => "'#{snapname}'"
        end

      end

      class Mock

        def local_revert_to_snapshot(vmname, snapname)
          raise "Server does not exist" unless data[:servers][vmname]
          raise "Snapshot does not exist" unless data[:servers][vmname][:snapshots].include?(snapname)
          # Noop - data state doesn't change
          true
        end

      end
    end
  end
end
