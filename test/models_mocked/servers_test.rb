require 'minitest/autorun'
require File.expand_path('../../test_helper', __FILE__)

class ServersTest < MiniTest::Unit::TestCase
  def setup
    Fog.mock!
    @compute = Fog::Compute.new(:provider => 'octocloud')
  end

  def teardown
    Fog.unmock!
  end

  def test_servers_returns_list
    assert @compute.servers.kind_of? Array
  end

  def test_servers_create_server
    res = @compute.servers.create(:memory => 123, :type => :esx, :cube => 'test')
    assert res.kind_of? Fog::Compute::Octocloud::Server
    assert res.type == :esx
  end
end
