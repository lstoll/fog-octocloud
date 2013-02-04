module Fog
  module Compute
    class Octocloud
      class Real

        def local_create_vm(boxname, vmname)
          target = @vm_dir.join(vmname)
          target.mkdir unless target.exist?

          source = @box_dir.join(boxname)

          # Copy the VMX over
          FileUtils.cp(Pathname.glob(source.join("*.vmx")).first,
                       target.join(vmname + ".vmx"))

          # Copy all VMDK's over
          Pathname.glob(source.join('*.vmdk')) do |f|
            FileUtils.cp f.expand_path, target
          end

          # TODO: Need to reset MAC/ID/name etc!!
          setup_uuid_mac(vmname)
          true
        end

        private

        def setup_uuid_mac(name)
          vmx = vmx_for_vm(name)
          VMXFile.with_vmx_data(vmx) do |data|
            data.delete "ethernet0.addressType"
            data.delete "uuid.location"
            data.delete "uuid.bios"
            data.delete "ethernet0.generatedAddress"
            data.delete "ethernet1.generatedAddress"
            data.delete "ethernet0.generatedAddressOffset"
            data.delete "ethernet1.generatedAddressOffset"
            data.delete 'displayname'
            data['displayName'] = "tenderloin-" + name
          end


        end

      end
    end
  end
end
