require 'minitest/autorun'
require File.expand_path('../../test_helper', __FILE__)
require 'tmpdir'

class LocalSnapshotRequestsTest < MiniTest::Unit::TestCase
  def setup
    @td = Pathname.new(Dir.mktmpdir)
    @compute = Fog::Compute.new(:provider => 'octocloud', :local_dir => @td.to_s)
    @compute.vmrunner = RecordingRunner
  end

  def teardown
    RecordingRunner.commands.clear
    @td.rmtree
  end

  def test_recording_runner
    RecordingRunner.run('testcmd', {})
    assert_equal RecordingRunner.commands.pop, ['testcmd', {}]
  end

  def test_create_snapshot
    @compute.local_snapshot('tvm', 'linked_clone')
    exptected_run = ['snapshot', {:opts => "'linked_clone'", :vmx => @td.join('vms/tvm/tvm.vmx')}]
    assert_equal RecordingRunner.commands.pop, exptected_run
  end

end

class LocalSnapshotMockRequestsTest < MiniTest::Unit::TestCase
  def setup
    Fog.mock!
    @compute = Fog::Compute.new(:provider => 'octocloud')
  end

  def teardown
    Fog.unmock!
  end

  def test_create_snapshot
    assert @compute.local_snapshot('name', 'snapname')
  end
end

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
