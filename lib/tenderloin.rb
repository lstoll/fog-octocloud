libdir = File.dirname(__FILE__)
$:.unshift(libdir)
PROJECT_ROOT = File.join(libdir, '..') unless defined?(PROJECT_ROOT)

# Setup
require 'tenderloin/util'

# Load config
require 'tenderloin/config'
require 'tenderloin/env'
Tenderloin::Env.load_config!

# Load CLI
require 'clamp'
require 'tenderloin/commands/main'

# Deps
# %w{tempfile open-uri json pathname logger uri net/http net/ssh archive/tar/minitar
  # net/scp fileutils}.each do |f|
  # require f
# end

# Glob require the rest
# Dir[File.join(PROJECT_ROOT, "lib", "tenderloin", "**", "*.rb")].each do |f|
  # require f
# end
