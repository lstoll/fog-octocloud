module Tenderloin
  class FusionVM


    def initialize(vmx)
      @vmx = vmx
    end

    def start_fusion
      # Ensure fusion is running.
      `if [[ -z $(pgrep 'VMware Fusion') ]]; then open /Applications/VMware\\ Fusion.app ; sleep 5 ; fi`
    end


    def enable_shared_folders
      run 'enableSharedFolders'
    end

    def share_folder(name, hostpath)
      # Try and clean up first, to handle path changes.
      begin
        run 'removeSharedFolder', "#{name}"
      rescue
      end
      run 'addSharedFolder', "#{name} #{hostpath}"
    end


    def to_hash
      {:ip => ip, :running => running?}
    end
  end
end
