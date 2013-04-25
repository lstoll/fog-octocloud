require 'minitest/autorun'
require File.expand_path('../../test_helper', __FILE__)
require 'tmpdir'

class LocalCreateVMRequestsTest < MiniTest::Unit::TestCase
  def setup
    @td = Pathname.new(Dir.mktmpdir)
    @compute = Fog::Compute.new(:provider => 'octocloud', :local_dir => @td.to_s)
    # Get a test box setup
    FileUtils.cp_r(fixture_dir.join('test-box'), @td.join('boxes'))
    @compute.vmrunner = RecordingRunner
  end

  def teardown
    RecordingRunner.commands.clear
    @td.rmtree
  end

  def test_create_vm
    @compute.local_create_vm('test-box', 'new-vm')
    assert @td.join('vms/new-vm/test-box.vmdk').exist?,   "VMDK does not exist"
    assert @td.join('vms/new-vm/test-box.vmdk').symlink?, "VMDK is not a symlink"
    assert @td.join('vms/new-vm/new-vm.vmx').exist?,      "VMX does not exist"
    assert RecordingRunner.commands.pop[0] == 'snapshot', "Did not attempt snapshot"
  end

end
