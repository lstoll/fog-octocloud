require "helper"

# TODO - Global vars are so bad. Do this better.

describe "VMRequests" do
  it "creates a VM" do
    get_compute(:local).local_create_vm((ENV['LOCAL_TEST_VM_NAME'] || 'precise64'), 'spec-test-vm')
  end

  it "lists available vms" do
    res = get_compute(:local).local_list_defined_vms
    res.should_not be_empty
  end

  it "loads VM info" do
    res = get_compute(:local).local_get_vm(vm_path)
    res.should_not be_empty
    res.should be_kind_of Hash
  end

  it "starts the VM" do
    get_compute(:local).local_start_vm(vm_path)
    get_compute(:local).local_get_vm(vm_path)['vm']['running'].should be_true
  end

  it "gets the IP" do
    get_compute(:local).local_get_vm(vm_path)['vm']['ip'].should_not be_nil
  end

  it "stops the VM" do
    get_compute(:local).local_stop_vm(vm_path)
    get_compute(:local).local_get_vm(vm_path)['vm']['running'].should be_false
  end

  it "destroys the VM" do
    lambda { get_compute(:local).local_destroy_vm(vm_path) }.should_not raise_error
  end

end
