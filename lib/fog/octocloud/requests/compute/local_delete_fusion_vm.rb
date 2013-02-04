module Fog
  module Compute
    class Octocloud
      class Real

        def local_delete_fusion_vm(name)
          vmx = vmx_for_vm(name)
          (1..10).each do |i|
            begin
              vmrun 'deleteVM', :vmx => vmx
            rescue
              sleep 2
              next
            end
            break
          end
        end

      end
    end
  end
end
