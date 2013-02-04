require 'open-uri'
require 'archive/tar/minitar'
require 'fog/tenderfusion/ovftool'

module Fog
  module Compute
    class Tenderfusion
      class Real

        def local_import_box(boxname, src)
          target = @box_dir.join(boxname)
          target.mkdir unless target.exist?
          input = Archive::Tar::Minitar::Input.new(open(src))
          input.each do |entry|
            input.extract_entry(target, entry)
          end

          # DO WE CONVERT??

          if !Dir[target.join('*.vmx')].empty?
            # We can do nothing - it's already good for vmware
          elsif !Dir[target.join('Vagrantfile')].empty?
            # Need to import from Vagrant. Convert the ovf to vmx using OVFtool, then write a base tenderfile
            convert_ovf(target)
          else
            raise "Invalid box - No vmx or Vagrantfile"
          end

        end

        private

        def convert_ovf(path)
          ovf = path.join('box.ovf')
          vmx = path.join('vmwarebox.vmx')
          OVFTool.ovf2vmx(ovf.to_s, vmx.to_s, :lax => true)
          FileUtils.rm_rf(path)
          FileUtils.mv(path.to_s + ".vmwarevm", path)
        end

      end
    end
  end
end
