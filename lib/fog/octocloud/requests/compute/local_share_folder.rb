module Fog
  module Compute
    class Octocloud
      class Real

        def local_share_folder(vmname, name, hostpath)
          vmx = vmx_for_vm(vmname)
          hostpath = Pathname.new(hostpath).expand_path
          # Try and clean up first, to handle path changes.
          begin
            vmrun 'removeSharedFolder', :opts => "#{name}", :vmx => vmx
          rescue
          end
          vmrun 'addSharedFolder', :opts => "#{name} #{hostpath}", :vmx => vmx
        end

        def local_enable_shared_folders(vmx)
          vmx = vmx_for_vm(vmx)
          # Just try it. Disable first, to force being set up
          vmrun 'disableSharedFolders', :vmx => vmx rescue nil
          vmrun 'enableSharedFolders', :vmx => vmx rescue nil
        end

      end
    end
  end
end
