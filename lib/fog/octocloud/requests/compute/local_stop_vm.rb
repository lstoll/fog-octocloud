module Fog
  module Compute
    class Octocloud
      class Real

        def local_stop_vm(name, opts={})
          vmx = vmx_for_vm(name)
          hard_opt = opts[:force] == true ? "hard" : "soft"
          begin
            Timeout::timeout(30) {
              vmrun 'stop', :opts => hard_opt, :vmx => vmx
            }
          rescue Timeout::Error
            # if being nice fails, force it.
            local_stop_vm(name, :force => true)
          end
        end

      end
    end
  end
end
