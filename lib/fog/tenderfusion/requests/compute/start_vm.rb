module Fog
  module Compute
    class Tenderfusion
      class Real

        def start_vm(vmx, headless=false)
          gui_opt = opts[:headless] == true ? "nogui" : "gui"
          vmrun('start', :opts => gui_opt)
        end

      end
    end
  end
end
