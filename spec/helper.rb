require 'fog-tenderloin'

FOG_MOCK = ENV['FOG_MOCK'] || false

def get_compute
  Fog::Compute.new(:provider => "Tenderloin", :loin_cmd => 'export BUNDLE_GEMFILE=/Users/lstoll/github/tenderloin/Gemfile; bundle exec loin')
end
