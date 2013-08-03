require 'fog-octocloud'
require 'pathname'
require 'tmpdir'
require 'fileutils'
require 'securerandom'
require 'digest/md5'

# Tiny Core OVA used for testing.
#
# It's a 7MB Tiny Core Linux image that can be imported
# and booted.
#
# FIXME: currently in my public Dropbox, should move it
# somewhere else.
#
TEST_OVA_URL = "https://dl.dropboxusercontent.com/u/116321/tinycore-477.ova"
TEST_OVA_MD5 = "f55b468fb1b9f13fdc076e53c0e4ad9e"

# Download OVA used for the tests and return the local
# path to the file.
#
# By default, if target_path isn't specified, a tmp file is created.
# If the target_path is specified and reuse is set to true,
# target_path will be returned if the OVA exist and MD5 matches.
#
# Cleaning the downloaded OVA file and re-using it
# must be handled by the user.
#
def download_test_ova(target_path = nil, reuse = false)
  # Try to re-use previously downloaded OVA
  if target_path and \
     reuse and \
     File.exist?(target_path) and \
     Digest::MD5.file(target_path).hexdigest == TEST_OVA_MD5

    return target_path
  end

  # Use a fixed path instead of a random one
  if target_path
    output = target_path
  else
    output = File.join("/tmp", "#{SecureRandom.hex.to_s}.ova")
  end

  open(output, 'w') do |out|
    open TEST_OVA_URL do |ova|
      while buffer = ova.read(8192) do
        out.write buffer
      end
    end
  end

  if Digest::MD5.file(output).hexdigest != TEST_OVA_MD5
    raise "Invalid test OVA MD5"
  end
  output
end

def fixture_dir
  Pathname.new(File.dirname(__FILE__)).join('fixtures').expand_path
end

## Replacement command runner, can be used to see what was executed
class RecordingRunner
  attr_reader :commands

  def initialize
    @commands, @next_return = [], []
  end

  def run(cmd, args = {})
    # args[:vmx] = args[:vmx].to_s if args[:vmx].kind_of? Pathname
    @commands << [cmd, args]
    @next_return.pop
  end

  def add_return(val)
    @next_return << val
  end
end
