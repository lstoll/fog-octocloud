module Tenderloin
  class FusionVM


    def initialize(vmx)
      @vmx = vmx
    end

    def start_fusion
      # Ensure fusion is running.
      `if [[ -z $(pgrep 'VMware Fusion') ]]; then open /Applications/VMware\\ Fusion.app ; sleep 5 ; fi`
    end


    def to_hash
      {:ip => ip, :running => running?}
    end
  end
end
