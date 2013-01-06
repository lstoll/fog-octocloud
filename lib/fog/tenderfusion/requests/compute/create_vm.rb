module Fog
  module Compute
    class Tenderfusion
      class Real

        def create_vm(boxname, vmname)
          target = vm_dir.join(vmname)
          target.mkdir unless target.exist?

          source = box_dir.join(boxname)

          # Copy the VMX over
          FileUtils.cp(Pathname.glob(source.join("*.vmx")).first,
                       target.join(vmname + ".vmx"))

          # Copy all VMDK's over
          Pathname.glob(source.join('*.vmdk')) do |f|
            FileUtils.cp f.expand_path, target

          # TODO: Need to reset MAC/ID/name etc!!
          end

        end

      end
    end
  end
end
