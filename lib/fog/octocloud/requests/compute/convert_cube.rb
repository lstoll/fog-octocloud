require 'open-uri'

module Fog
  module Compute
    class Octocloud
      class Real

        protected

        def import_file(target, src, opts = {})
          case File.extname(src)
          when '.box'
            import_box(target, src, opts)
          when '.ova'
            import_ova(target, src, opts)
          else
            raise "Can't import non .box or .ova"
          end

        end

        # Imports a box (a tarball from vagrant or tenderloin)
        #
        # @param [Pathname] target destination directory of the box contents
        # @param [Pathname, String] path box source file (can be URL or file)
        # @param [Hash] opts extra options
        # @option opts [Boolean] :show_progress display progress when importing a remote box
        #
        def import_box(target, path, opts = {})
          if path.to_s =~ /^http/
            show_progress = opts.is_a?(Hash) ? opts[:show_progress] == true : false
            downloaded_file = download_file path.to_s, show_progress
            input = Archive::Tar::Minitar::Input.new(downloaded_file)
          else
            # need to coerce path to a string, so open-uri can figure what it is
            input = Archive::Tar::Minitar::Input.new(open(path.to_s))
          end
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

        # Imports an OVA
        #
        # @param [Pathname] target destination directory of the box contents
        # @param [Pathname, String] src OVA source file (can be URL or file)
        # @param [Hash] opts extra options
        # @option opts [Boolean] :show_progress display progress when importing a remote box
        #
        def import_ova(target, src, opts = {})
          # First, dump the contents in to a tempfile.
          tmpfile = Tempfile.new(['ova-import', '.ova'])
          if src.to_s =~ /^http/
            show_progress = opts.is_a?(Hash) ? opts[:show_progress] == true : false
            downloaded = download_file(src, show_progress)
            FileUtils.mv downloaded.path, tmpfile.path
          else
            tmpfile.write(open(src).read)
          end
          tmpfile_path = Pathname.new(tmpfile)
          convert_ova(tmpfile_path, target)
        end

        def convert_ova(ova, target)
          vmx = target.join('vmwarebox.vmx')
          OVFTool.convert(ova.to_s, vmx)
          # OVFTool.convert creates ~/.octocloud/boxes/<cubename>.vmwarevm
          # We want to rename it to <cubename> removing the .vmwarevm 
          # directory suffix.
          #
          # Except on linux hosts with Workstation/Player
          unless RUBY_PLATFORM =~ /linux/
            File.rename(target.cleanpath.to_s + ".vmwarevm", target)
          end
        end

        def convert_box_ovf(path)
          ovf = path.join('box.ovf')
          vmx = path.join('vmwarebox.vmx')
          OVFTool.convert(ovf.to_s, vmx.to_s, :lax => true)
          # things work a little different under linux ovftool. So handle appropriately
          if Pathname.new(path.to_s + ".vmwarevm").exist?
            # This was a mac ovftool conversion
            FileUtils.rm_rf(path)
            FileUtils.mv(path.to_s + ".vmwarevm", path)
          else
            # Delete items we didn't create
            remove = path.entries.delete_if {|f| f.to_s =~ /vmwarebox/ || f.to_s == '.' || f.to_s == '..'}
            remove.each {|f| path.join(f).delete }
          end

        end

        # Download remote file from URL and optionally print progress.
        #
        # If the progressbar gem is installed it will be automatically used
        # to display the download progress, gracefully degrading to a simple
        # progress animation otherwise.
        #
        # @param [String] url file URL
        # @param [Boolean] show_progress display progress when true
        #
        def download_file(url, show_progress = false)
          if show_progress
            pbar = nil
            begin
              require 'progressbar'
            rescue LoadError => e
              Fog::Logger.warning "progressbar rubygem not found. Install it for fancier progress."
              pbar = :noop
            end
            open(
              url,
              :content_length_proc => lambda { |total|
                if pbar != :noop
                  if total && 0 < total
                    pbar = ProgressBar.new("Downloading", total)
                    pbar.file_transfer_mode
                  end
                end
              },
              :progress_proc => lambda { |read_size|
                if pbar != :noop
                  pbar.set read_size if pbar
                else
                  print "\rDownloading... #{"%.2f" % (read_size/1024.0**2)} MB"
                end
              }
            )
          else
            open(url)
          end
        end

      end
    end
  end
end
