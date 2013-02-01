require "helper"

# TODO - Global vars are so bad. Do this better.

describe "VMRequests" do
  it "creates a VM"

  it "lists available vms" do
    res = get_compute.list_vms
    res.should_not be_empty
  end

  it "loads VM info" do
    res = get_compute.get_vm(vm_path)
    res.should_not be_empty
    res.should be_kind_of Hash
  end

  it "starts the VM" do
    get_compute.start_vm(vm_path)
    get_compute.get_vm(vm_path)['vm']['running'].should be_true
  end

  it "gets the IP" do
    get_compute.get_vm(vm_path)['vm']['ip'].should_not be_nil
  end

  it "stops the VM" do
    get_compute.stop_vm(vm_path)
    get_compute.get_vm(vm_path)['vm']['running'].should be_false
  end

  it "destroys the VM" do
    lambda { get_compute.destroy_vm(vm_path) }.should_not raise_error
  end

  describe "CreateRequest" do
    it "should raise without valid options" do
      expect { get_compute.create_vm({}) }.to raise_error
    end

    it "should return the new VM's ID when creating" do
      res = get_compute.create_vm({'type' => "esx", 'cube' => "precise64", 'memory' => 512})
      $new_id = res["id"]
      $new_id.should_not eql(nil)
    end
  end

  describe "ListRequest" do
    it "should list the created VM" do
      res = get_compute.list_vms
      res.any? {|v| v["id"].to_s == $new_id.to_s}.should eql(true)
    end
  end

  describe "LookupRequest" do
    it "should return the IP and running state of the machine" do
      res = {}
      # Need to give the machine time to boot and get the data.
      (1..60).each do |i|
        begin
          res = get_compute.lookup_vm($new_id)
          break if res["ip"] && res["running"]
        rescue
        ensure
          sleep 2
        end
      end
      res["ip"].should_not eql(nil)
      res["running"].should_not eql(false)
    end
  end

  describe "DeleteRequest" do
    it "should successfully remove the machine" do
      get_compute.delete_vm $new_id
      res = get_compute.list_vms
      res.any? {|v| v["id"].to_s == $new_id.to_s}.should_not eql(true)
    end
  end
end
