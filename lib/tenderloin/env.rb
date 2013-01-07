module Tenderloin
  class Env
    BOXFILE_NAME = "Tenderfile"

    # Initialize class variables used
    @@persisted_vm = nil
    @@root_path = nil
    @@box = nil

    extend Tenderloin::Util

    class << self
      def persisted_vm; @@persisted_vm; end
      def root_path; @@root_path; end
      def dotfile_path
        loinsplit = File.split($ROOTFILE_NAME)
        loinsplit[-1] = "." + loinsplit[-1] + ".loinstate"
        File.join(root_path, *loinsplit)
      end

      def load!
        load_root_path!
        load_config!
        load_vm!
      end

      def load_config!
        # Prepare load paths for config files
        load_paths = [File.join(PROJECT_ROOT, "config", "default.rb")]
        load_paths << File.join(root_path, $ROOTFILE_NAME) if root_path

        # Then clear out the old data
        Config.reset!

        load_paths.each do |path|
          logger.info "Loading config from #{path}..."
          load path if File.exist?(path)
        end

        # Execute the configurations
        Config.execute!
      end

      def load_vm!
        return if !root_path || !File.file?(dotfile_path)

        File.open(dotfile_path) do |f|
          @@persisted_vm = Tenderloin::VM.find(f.read)
        end
      rescue Errno::ENOENT
        @@persisted_vm = nil
      end

      def persist_vm(vm_id)
        File.open(dotfile_path, 'w+') do |f|
          f.write(vm_id)
        end
      end

      def load_root_path!(path=nil)
        path ||= Pathname.new(Dir.pwd)

        # Stop if we're at the root. 2nd regex matches windows drives
        # such as C:. and Z:. Portability of this check will need to be
        # researched.
        return false if path.to_s == '/' || path.to_s =~ /^[A-Z]:\.$/

        file = "#{path}/#{$ROOTFILE_NAME}"
        if File.exist?(file)
          @@root_path = path.to_s
          return true
        end

        load_root_path!(path.parent)
      end

      def require_root_path
        if !root_path
          error_and_exit(<<-msg)
A `#{$ROOTFILE_NAME}` was not found! This file is required for tenderloin to run
since it describes the expected environment that tenderloin is supposed
to manage. Please create a #{$ROOTFILE_NAME} and place it in your project
root.
msg
        end
      end

      def require_persisted_vm
        require_root_path

        if !persisted_vm
          error_and_exit(<<-error)
The task you're trying to run requires that the tenderloin environment
already be created, but unfortunately this tenderloin still appears to
have no box! You can setup the environment by setting up your
#{$ROOTFILE_NAME} and running `tenderloin up`
error
          return
        end
      end

      def compute
        @@fog_compute ||= begin
                            fog_conf = Tenderloin.config.fog
                            require "fog-#{fog_conf.provider.to_s}"
                            opts = fog_conf.options.merge({:provider => fog_conf.provider})
                            Fog::Compute.new(opts)
        end
      end
    end
  end
end
