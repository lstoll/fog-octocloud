module Fog
  module Compute
    class VMXFile

      def self.load(filename)
        data = {}
        File.open(filename).each do |line|
          next if line =~ Regexp.new(Regexp.quote("#!/usr/bin/vmware"))
          parts = line.split('=')
          data[parts[0].strip] = parts[1].strip.gsub!(/^"(.*?)"$/,'\1')
        end
        data
      end

      def self.write(filename, data)
        File.open(filename, 'w') do |f|
          data.each do |k,v|
            f.puts "#{k} = \"#{v}\""
          end
        end
      end

      def self.with_vmx_data(filename, &block)
        data = load(filename)
        block.call(data)
        write(filename, data)
      end

      # Sane defaults for a VMX file.
      #
      # We we'll want to change displayName, guestOS,
      # memsize, and numvcpus when creating new VMX files
      # from this template.
      #
      # List of guestOS values
      # http://sanbarrow.com/vmx/vmx-guestos.html
      #
      def self.defaults
        <<-EOH
        config.version = "8"
        virtualHW.version = "6"
        scsi0.present = "FALSE"
        scsi0.virtualDev = "lsilogic"
        Ethernet0.virtualDev = "vlance"
        Ethernet0.present = "TRUE"
        Ethernet0.connectionType = "bridged"
        priority.grabbed = "normal"
        priority.ungrabbed = "normal"
        powerType.powerOff = "hard"
        powerType.powerOn = "hard"
        powerType.suspend = "hard"
        powerType.reset = "hard"
        floppy0.present = "FALSE"
        ide0:0.present = "TRUE"
        ide0:0.fileName = ""
        displayName = "Linux"
        guestOS = "otherlinux"
        memsize = "512"
        numvcpus = "1"
        EOH
      end

    end
  end
end
