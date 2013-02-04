module Fog
  module Compute
    class Tenderfusion
      class Real

        def stop_vm(name, opts={})
          vmx = vmx_for_vm(name)
          hard_opt = opts[:force] == true ? "hard" : "soft"
          vmrun 'stop', :opts => hard_opt, :vmx => vmx
        end

      end
    end
  end
end