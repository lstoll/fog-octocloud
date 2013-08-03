require 'minitest/autorun'
require File.expand_path('../../test_helper', __FILE__)
require 'tmpdir'

class LocalImportBoxTest < MiniTest::Unit::TestCase

  def setup
    @td = Pathname.new(Dir.mktmpdir)
    @compute = Fog::Compute.new(:provider => 'octocloud', :local_dir => @td.to_s)
    # Download OVA
    # We also want to re-use it in all these tests so we fix the path
    @tmp_ova_path = "/tmp/fog-octocloud-test-ova.ova"
    @test_ova = download_test_ova @tmp_ova_path, true
  end

  def teardown
    @td.rmtree
  end

  def test_local_import_box
    box_path = @td.join('boxes/fog-octocloud-test-ova')
    @compute.local_import_box 'fog-octocloud-test-ova', @test_ova, TEST_OVA_MD5
    assert File.directory?(box_path)
    assert Dir["#{box_path}/*.vmx"].size == 1
    # OVAs may have more than one VMDK IIRC
    assert Dir["#{box_path}/*.vmdk"].size >= 1
  end

end
