module Fog
  module Compute
    class Octocloud
      class Real

        # Takes the name of the VM, and a hash of fields to set.
        # If the value is nil, the field will be deleted
        def local_edit_vmx(name, fields)
          vmx = vmx_for_vm(name)

          VMXFile.with_vmx_data(vmx) do |data|
            fields.each do |k, v|
              key = k.to_s.downcase
              if v.nil?
                data.delete(key)
              else
                data[key] = v
              end
            end
          end

          true
        end

      end
    end
  end
end
