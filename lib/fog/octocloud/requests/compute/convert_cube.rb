require 'open-uri'

module Fog
  module Compute
    class Octocloud
      class Real

        protected

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
          # need to coerce path to a string, so open-uri can figure what it is
          input = Archive::Tar::Minitar::Input.new(open(path.to_s))
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
          if target.join('.vmwarevm').exist?
            # Probably on OS X where it makes a 'bundle' vm. Move it in to original place
            FileUtils.rm_rf(target)
            FileUtils.mv(target.join('.vmwarevm'), target)
          end
        end

        def convert_box_ovf(path)
          ovf = path.join('box.ovf')
          vmx = path.join('vmwarebox.vmx')
          OVFTool.convert(ovf.to_s, vmx.to_s, :lax => true)
          # things work a little different under linux ovftool. So handle appropriately
          if path.join(".vmwarevm").exist?
            # This was a mac ovftool conversion
            FileUtils.rm_rf(path)
            FileUtils.mv(path.join(".vmwarevm"), path)
          else
            # Delete items we didn't create
            remove = path.entries.delete_if {|f| f.to_s =~ /vmwarebox/ || f.to_s == '.' || f.to_s == '..'}
            remove.each {|f| path.join(f).delete }
          end

        end

      end
    end
  end
end
