module Fog
  module Compute
    class Octocloud
      class Real

        def local_create_vm(boxname, vmname)
          target = @vm_dir.join(vmname)
          target.mkdir unless target.exist?

          source = @box_dir.join(boxname)

          raise "Invalid Cube Specified" unless source.exist?

          # Copy the VMX over
          FileUtils.cp(Pathname.glob(source.join("*.vmx")).first,
                       target.join(vmname + ".vmx"))

          # Symlink the VMDK's
          Pathname.glob(source.join('*.vmdk')) do |f|
            FileUtils.ln_s f.expand_path, target.join(f.basename)
          end

          setup_uuid_mac(vmname)

          # Snapshot the VM to ensure we don't write to the original disk
          local_snapshot(vmname, 'linked_clone')
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
            data['displayName'] = name
          end


        end

      end
    end
  end
end
