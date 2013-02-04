require "helper"

# TODO - Global vars are so bad. Do this better.

# describe "ServerModel" do
#   it "lists the sample VM" do
#     get_compute.servers.count.should eql(1)
#   end

#   it "starts the VM" do
#     # Need to give the machine time to boot and get the data.
#     get_compute.servers.first.start
#     get_compute.servers.first.running?.should be_true
#   end

#   it "can SSH in to the VM" do
#     get_compute.servers.first.sshable?.should be_true
#   end

#   it "can destroy the VM" do
#     lambda {get_compute.servers.first.destroy}.should_not raise_error
#   end
# end

describe "VMModels" do
  describe "CreateRequest" do
    it "returns the new VM" do
      # unused stuff should be ignored
      s = get_compute(:local).servers.create({name: 'model-spec-vm', type: "esx", cube: "precise64", memory: 512})
      $new_id = s.identity
      s.should_not eql(nil)
    end
  end

  describe "ListRequest" do
    it "should list the created VM" do
      res = get_compute(:local).servers
      res.any? {|v| v.identity.to_s == $new_id.to_s}.should eql(true)
    end
  end

  describe "LookupRequest" do
    res = nil
    it "should return the IP and running state of the machine" do
      # Need to give the machine time to boot and get the data.
      (1..60).each do |i|
        res = get_compute(:local).servers.get($new_id)
        break if res && res.ip && res.running?
        sleep 2
      end
      res.ip.should_not eql(nil)
      res.running?.should_not eql(false)
    end
  end

  describe "DeleteRequest" do
    it "should successfully remove the machine" do
      get_compute(:local).servers.get($new_id).destroy
      res = get_compute(:local).servers
      res.any? {|v| v.identity.to_s == $new_id.to_s}.should_not eql(true)
    end
  end
end
