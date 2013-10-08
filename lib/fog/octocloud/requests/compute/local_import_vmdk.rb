require 'tempfile'

module Fog
  module Compute
    class Octocloud
      class Real

        def local_import_vmdk(boxname, src, md5, opts = {})
          target = @box_dir.join(boxname)
          target.mkdir unless target.exist?

          begin
            import_vmdk(target, src, opts)
          rescue Exception => e
            target.rmtree
            raise e
          end

          File.open(target.join('.md5'), 'w') {|f| f.write(md5) }
        end

        private
        def import_vmdk(target, path, opts = {})
          # make sure opts is an empty hash if nil
          opts = {} if opts.nil?
          vmx = Tempfile.new('fog-octocloud-vmx')
          vmx.write VMXFile.defaults
          vmx.close
          disk_path = target.join('vmwarebox-disk1.vmdk').to_s
          VMXFile.with_vmx_data(vmx.path) do |data|
            data['displayName'] = opts[:name] || File.basename(path.to_s, '.vmdk')
            data['ide0:0.fileName'] = disk_path
            {
              'guestOS'  => :guest_os,
              'memsize'  => :memory,
              'numvcpus' => :cpus
            }.each do |k, v|
              data[k] = opts[v] if opts[v]
            end
          end
          FileUtils.mv vmx.path, target.join('vmwarebox.vmx').to_s
          FileUtils.cp path, disk_path
        end

      end
    end
  end
end
