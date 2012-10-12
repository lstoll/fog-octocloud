require 'fog-octocloud'

FOG_MOCK = ENV['FOG_MOCK'] || false
OCTOCLOUD_API_KEY = ENV['OCTOCLOUD_API_KEY'] || raise("OCTOCLOUD_API_KEY must be set")
OCTOCLOUD_URL = ENV['OCTOCLOUD_URL'] || raise("OCTOCLOUD_URL must be set")

def get_compute
  Fog::Compute.new(:provider => "Octocloud", :octocloud_url => OCTOCLOUD_URL, :octocloud_api_key => OCTOCLOUD_API_KEY)
end
