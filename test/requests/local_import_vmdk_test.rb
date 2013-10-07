require 'minitest/autorun'
require File.expand_path('../../test_helper', __FILE__)
require 'tmpdir'

class LocalImportVMDKTest < MiniTest::Unit::TestCase

  def setup
    @td = Pathname.new(Dir.mktmpdir)
    @compute = Fog::Compute.new(:provider => 'octocloud', :local_dir => @td.to_s)
    # Create fake VMDK
    @fake_vmdk = @td.join('test.vmdk')
    File.open(@fake_vmdk, 'w') { |f| f.puts 'bleh' }
  end

  def teardown
    @td.rmtree
  end

  def test_local_import_vmdk_from_file
    #return if travis_ci?
    box_path = @td.join('boxes/fog-octocloud-test-ova')
    @compute.local_import_vmdk 'fog-octocloud-test-ova', 
                               @fake_vmdk,
                               'FAKEMD5',
                               :guest_os => 'otherlinux'
    assert File.directory?(box_path)
    vmx = Dir["#{box_path}/*.vmx"].first
    assert !vmx.nil?
    assert Dir["#{box_path}/*.vmdk"].size >= 1

  end

  def test_generated_vmx
    box_path = @td.join('boxes/fog-octocloud-test-ova')
    @compute.local_import_vmdk 'fog-octocloud-test-ova',
                               @fake_vmdk,
                               'FAKEMD5',
                               :guest_os => 'ubuntu-64',
                               :cpus => 4,
                               :memory => 2048
    vmx = Dir["#{box_path}/*.vmx"].first
    Fog::Compute::VMXFile.with_vmx_data(vmx) do |data|
      assert data['ide0:0.fileName'] == box_path.join('vmwarebox-disk1.vmdk').to_s
      assert data['memsize'] == '2048'
      assert data['numvcpus'] == '4'
      assert data['guestOS'] == 'ubuntu-64'
    end
  end

end
