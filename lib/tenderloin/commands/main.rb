# This is the entry point that contains the global options.

module Tenderloin
  class CLI < Clamp::Command

    include Tenderloin::Util

    option "--file", "FILE", "The environment description file. Defaults to Tenderfile", :default => 'Tenderfile'

    subcommand "init", "Initialize the repository" do
      option "--flavour2", "FLAVOUR2", "ice-cream flavour2"
      def execute
        # ...
        puts "flav #{flavour}"
        puts "flav2 #{flavour2}"

        # p Tenderloin.config
        # p Tenderloin::Env.compute
      end

    end

    private

    def load_env!
      $ROOTFILE_NAME = file.dup.freeze
      Env.load!
    end

    def config
      Tenderloin.config
    end

  end
end

## Load the subcommands

require 'tenderloin/commands/up'
require 'tenderloin/commands/destroy'
