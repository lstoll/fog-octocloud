module Fog
  module Compute
    class << self
      alias_method :pre_octocloud_new, :new

      def new(attributes)
        dup_attr = attributes.dup # prevent delete from having side effects
        provider = dup_attr.delete(:provider).to_s.downcase.to_sym
        if provider == :octocloud
          require 'fog/octocloud/compute'
          Fog::Compute::Octocloud.new(dup_attr)
        else
          pre_octocloud_new(attributes)
        end
      end
    end

    class Server
      def run(script, run_dir = Pathname.new('/tmp'), &block)
        script = Pathname(script)
        path   = run_dir.join(script.basename)

        path_string = path.to_s

        scp(script.to_s, path_string)
        ssh("chmod +x #{path_string}")
        ssh(path_string, &block)
      end

      def fix_key_permissions!
        private_key_file.chmod(0600)
      end

      def shell
        fix_key_permissions!

        command = %w[ssh]
        command << '-i' << private_key_file.realpath.to_s
        command << '-o' << 'UserKnownHostsFile=/dev/null'
        command << '-o' << 'StrictHostKeyChecking=no'
        command << '-p' << '22'
        command << "#{username}@#{public_ip_address}"

        system(*command)
      end
    end
  end
end

