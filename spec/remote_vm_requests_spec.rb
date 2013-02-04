require "helper"

# TODO - Global vars are so bad. Do this better.

describe "VMRequests" do

  describe "CreateRequest" do
    it "should raise without valid options" do
      expect { get_compute(:remote).remote_create_vm({}) }.to raise_error
    end

    it "should return the new VM's ID when creating" do
      res = get_compute(:remote).remote_create_vm({'type' => "esx", 'cube' => "precise64", 'memory' => 512})
      $new_id = res["id"]
      $new_id.should_not eql(nil)
    end
  end

  describe "ListRequest" do
    it "should list the created VM" do
      res = get_compute(:remote).remote_list_vms
      res.any? {|v| v["id"].to_s == $new_id.to_s}.should eql(true)
    end
  end

  describe "LookupRequest" do
    it "should return the IP and running state of the machine" do
      res = {}
      # Need to give the machine time to boot and get the data.
      (1..60).each do |i|
        begin
          res = get_compute(:remote).remote_lookup_vm($new_id)
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
      get_compute(:remote).remote_delete_vm $new_id
      res = get_compute(:remote).remote_list_vms
      res.any? {|v| v["id"].to_s == $new_id.to_s}.should_not eql(true)
    end
  end
end
