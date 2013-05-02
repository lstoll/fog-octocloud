require 'minitest/autorun'
require File.expand_path('../../test_helper', __FILE__)
require 'tmpdir'

class LocalSnapshotRequestsTest < MiniTest::Unit::TestCase
  def setup
    @td = Pathname.new(Dir.mktmpdir)
    @compute = Fog::Compute.new(:provider => 'octocloud', :local_dir => @td.to_s)
    @runner = @compute.vmrunner = RecordingRunner.new
  end

  def teardown
    @td.rmtree
  end

  def test_recording_runner
    @runner.run('testcmd', {})
    assert_equal @runner.commands.pop, ['testcmd', {}]
  end

  def test_create_snapshot
    @compute.local_snapshot('tvm', 'linked_clone')
    exptected_run = ['snapshot', {:opts => "'linked_clone'", :vmx => @td.join('vms/tvm/tvm.vmx')}]
    assert_equal @runner.commands.pop, exptected_run
  end

  def test_list_snapshots
    @runner.add_return("total snapshots: 3\nsnapshot1\nsnapshot2\nsnapshot3\n")
    assert_equal @compute.local_list_snapshots('tvm'), ['snapshot1', 'snapshot2', 'snapshot3']
  end

  def test_revert_snapshot
    @runner.add_return("total shapshots: 1\nsnapshot1")
    @compute.local_revert_to_snapshot('tvm', 'snapshot1')
    assert_equal @runner.commands.pop, ['revertToSnapshot', [:opts => "'snapshot1"]]
    @runner.add_return("total shapshots: 1\nsnapshot2")
    assert_raises(Exception) { @compute.local_revert_to_snapshot('snapshot1') }
  end

  def test_delete_shapshot
    @runner.add_return("total shapshots: 1\nsnapshot1")
    @compute.local_delete_snapshot('tvm', 'snapshot1')
    assert_equal @runner.commands.pop, ['deleteSnapshot', [:opts => "'snapshot1"]]
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
