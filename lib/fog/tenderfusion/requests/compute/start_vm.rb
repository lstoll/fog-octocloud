module Fog
  module Compute
    class Tenderfusion
      class Real

        def start_vm(name, opts={})
          vmx = vmx_for_vm(name)
          gui_opt = opts[:headless] == true ? "nogui" : "gui"
          vmrun('start', :opts => gui_opt, :vmx => vmx)
        end

      end
    end
  end
end
