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

  it "loads VM state" do
    res = get_compute(:local).local_vm_running('spec-test-vm')
    res.should be_false
  end

  it "starts the VM" do
    get_compute(:local).local_start_vm('spec-test-vm')
    get_compute(:local).local_vm_running('spec-test-vm').should be_true
  end

  it "gets the IP" do
    get_compute(:local).local_vm_ip('spec-test-vm').should_not be_nil
  end

  it "stops the VM" do
    get_compute(:local).local_stop_vm('spec-test-vm')
    get_compute(:local).local_vm_running('spec-test-vm').should be_false
  end

  it "destroys the VM" do
    lambda { get_compute(:local).local_delete_vm_files('spec-test-vm') }.should_not raise_error
  end

end
