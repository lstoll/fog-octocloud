module Fog
  module Compute
    class Tenderfusion
      class Real

        def start_vm(vmx, headless=false)
          gui_opt = opts[:headless] == true ? "nogui" : "gui"
          vmrun('start', :opts => gui_opt, :vmx => vmx)
        end

      end
    end
  end
end
