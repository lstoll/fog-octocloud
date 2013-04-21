require 'fog-octocloud'

# Default to mock mode
unless ENV["FOG_MOCK"] == "false"
  Fog.mock!
end
