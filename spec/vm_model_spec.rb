require "helper"

# TODO - Global vars are so bad. Do this better.

describe "ServerModel" do
  it "lists the sample VM" do
    get_compute.servers.count.should eql(1)
  end

  it "starts the VM" do
    # Need to give the machine time to boot and get the data.
    get_compute.servers.first.start
    get_compute.servers.first.running?.should be_true
  end

  it "can SSH in to the VM" do
    get_compute.servers.first.sshable?.should be_true
  end

  it "can destroy the VM" do
    lambda {get_compute.servers.first.destroy}.should_not raise_error
  end
end
