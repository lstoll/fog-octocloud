module Fog
  module Compute
    class Octocloud

      private

      def import_file(target, src)
        case File.extname(src)
        when '.box'
          import_box(target, src)
        when '.ova'
          import_ova(target, src)
        else
          raise "Can't import non .box or .ova"
        end

      end

      ## Imports a box - this is a tarball from vagrant or tenderloin.
      # Path can be URL or file
      def import_box(target, path)
        input = Archive::Tar::Minitar::Input.new(open(path))
        input.each do |entry|
          input.extract_entry(target, entry)
        end

        # DO WE CONVERT??

        if !Dir[target.join('*.vmx')].empty?
          # We can do nothing - it's already good for vmware
        elsif !Dir[target.join('Vagrantfile')].empty?
          # Need to import from Vagrant. Convert the ovf to vmx using OVFtool, then write a base tenderfile
          convert_box_ovf(target)
        else
          raise "Invalid box - No vmx or Vagrantfile"
        end
      end

      ## Imports a ova.
      def import_ova(target, src)
        # First, dump the contents in to a tempfile.
        tmpfile = Tempfile.new(['ova-import', '.ova'])
        tmpfile.write(open(src).read)
        tmpfile_path = Pathname.new(tmpfile)
        convert_ova(tmpfile_path, target)
      end

      def convert_ova(ova, target)
        vmx = target.join('vmwarebox.vmx')
        OVFTool.convert(ova.to_s, vmx.to_s)
        FileUtils.rm_rf(target)
        FileUtils.mv(target.to_s + ".vmwarevm", target)
      end

      def convert_box_ovf(path)
        ovf = path.join('box.ovf')
        vmx = path.join('vmwarebox.vmx')
        OVFTool.convert(ovf.to_s, vmx.to_s, :lax => true)
        FileUtils.rm_rf(path)
        FileUtils.mv(path.to_s + ".vmwarevm", path)
      end

    end
  end
end
