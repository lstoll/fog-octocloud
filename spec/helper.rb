require 'fog-octocloud'

FOG_MOCK = ENV['FOG_MOCK'] || false

def get_compute(type)
  case type
  when :remote
    api_key = ENV['OCTOCLOUD_API_KEY'] || raise("OCTOCLOUD_API_KEY must be set for remote compute")
    url = ENV['OCTOCLOUD_URL'] || raise("OCTOCLOUD_URL must be set for remote compute")
    Fog::Compute.new(:provider => "Octocloud", :octocloud_url => url, :octocloud_api_key => api_key)
  when :local
    Fog::Compute.new(:provider => 'octocloud')
  else
    raise ArgumentError.new("Invalid compute type requested")
  end
end
