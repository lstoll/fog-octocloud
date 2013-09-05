module Fog
  module Compute
    class Octocloud
      class Real

        def local_vm_ip(name)
          vmx = vmx_for_vm(name)
          ip = get_guest_var(vmx, 'ip')
          if ip && ip.strip =~ /^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$/
            ip = ip.strip
          else
            mac_address = VMXFile.load(vmx)["ethernet0.generatedAddress"]
            ip = dhcp_leases[mac_address]
          end
          ip
        end

        private

        def get_guest_var(vmx, var)
          vmrun 'readVariable', :opts => 'guestVar ' + var, :vmx => vmx
        end

        def dhcp_leases
          mac_ip = {}
          curLeaseIp = nil
          dhcp_leases_files.each do |f|
            File.open(f).each do |line|
              case line
              when /lease (.*) \{/
                curLeaseIp = $1
              when /hardware ethernet (.*);/
                mac_ip[$1] = curLeaseIp
              end
            end
          end
          mac_ip
        end

        def dhcp_leases_files
          case VMRun.platform
          when :linux
            Dir['/etc/vmware/vmnet*/dhcpd/dhcpd.leases']
          when :darwin
            Dir['/var/db/vmware/vmnet-dhcpd*.leases']
          else
            raise 'Unsuported platform, DHCP leases not found'
          end
        end

      end
    end
  end
end
