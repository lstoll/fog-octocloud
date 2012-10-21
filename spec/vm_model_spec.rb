require "helper"

# TODO - Global vars are so bad. Do this better.

describe "VMRequests" do
  describe "CreateRequest" do
    it "returns the new VM" do
      s = get_compute.servers.create({:type => "esx", :template => "precise64", :memory => 512})
      $new_id = s.identity
      s.should_not eql(nil)
    end
  end

  describe "ListRequest" do
    it "should list the created VM" do
      res = get_compute.servers
      res.any? {|v| v.identity.to_s == $new_id.to_s}.should eql(true)
    end
  end

  describe "LookupRequest" do
    res = nil
    it "should return the IP and running state of the machine" do
      # Need to give the machine time to boot and get the data.
      (1..60).each do |i|
        res = get_compute.servers.get($new_id)
        break if res && res.ip && res.running?
        sleep 2
      end
      res.ip.should_not eql(nil)
      res.running?.should_not eql(false)
    end
  end

  describe "DeleteRequest" do
    it "should successfully remove the machine" do
      get_compute.servers.get($new_id).destroy
      res = get_compute.list_vms
      res.any? {|v| v.identity.to_s == $new_id.to_s}.should_not eql(true)
    end
  end
end
