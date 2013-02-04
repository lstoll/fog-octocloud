module Fog
  module Compute
    class Octocloud
      class Real

        def local_delete_vm_files(vmname)
          target = @vm_dir.join(vmname)
          target.rmtree
        end

      end
    end
  end
end
