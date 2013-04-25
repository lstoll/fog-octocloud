require 'fog-octocloud'
require 'pathname'
require 'tmpdir'
require 'fileutils'

def fixture_dir
  Pathname.new(File.dirname(__FILE__)).join('fixtures').expand_path
end

## Replacement command runner, can be used to see what was executed
class RecordingRunner
  @@commands = []

  def self.run(cmd, args = {})
    # args[:vmx] = args[:vmx].to_s if args[:vmx].kind_of? Pathname
    @@commands << [cmd, args]
  end

  def self.commands
    @@commands
  end
end
