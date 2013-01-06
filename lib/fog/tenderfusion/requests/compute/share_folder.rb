module Fog
  module Compute
    class Tenderfusion
      class Real

        def share_folder(vmx, name, hostpath)
          # Try and clean up first, to handle path changes.
          begin
            vmrun 'removeSharedFolder', :opts => "#{name}", :vmx => vmx
          rescue
          end
          run 'addSharedFolder', :opts => "#{name} #{hostpath}", :vmx => vmx
        end

        private


        def enable_shared_folders(vmx)
          # Just try it.
          vmrun 'enableSharedFolders', :vmx => vmx rescue nil
        end

      end
    end
  end
end
