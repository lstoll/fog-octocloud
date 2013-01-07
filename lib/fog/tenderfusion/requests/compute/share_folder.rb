module Fog
  module Compute
    class Tenderfusion
      class Real

        def share_folder(vmname, name, hostpath)
          vmx = vmx_for_vm(vmname)
          # Try and clean up first, to handle path changes.
          begin
            vmrun 'removeSharedFolder', :opts => "#{name}", :vmx => vmx
          rescue
          end
          vmrun 'addSharedFolder', :opts => "#{name} #{hostpath}", :vmx => vmx
        end

        def enable_shared_folders(vmx)
          # Just try it.
          vmrun 'enableSharedFolders', :vmx => vmx rescue nil
        end

      end
    end
  end
end
