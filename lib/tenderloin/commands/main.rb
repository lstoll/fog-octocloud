# This is the entry point that contains the global options.

module Tenderloin
  class CLI < Clamp::Command

    include Tenderloin::Util

    option ["--file", "-f"], "FILE", "The environment description file. Defaults to Tenderfile", :default => 'Tenderfile'

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
require 'tenderloin/commands/halt'
require 'tenderloin/commands/ssh'
require 'tenderloin/commands/provision'
