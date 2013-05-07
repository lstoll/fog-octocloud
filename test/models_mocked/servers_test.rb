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

  def test_local_server_snapshotting
    @compute.data[:servers]['server1'] = {:snapshots => []}
    server = Fog::Compute::Octocloud::LocalServer.new(:id => 'server1', :service => @compute)
    assert_equal server.snapshots, []
    server.snapshot('snap1')
    assert_equal server.snapshots, ['snap1']
    # This doesn't really do anything in mock mode, so make sure the call is OK
    assert server.revert_to_snapshot('snap1')
    server.delete_snapshot('snap1')
    assert_equal server.snapshots, []
  end
end
