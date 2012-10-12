require "helper"

describe "CreateRequest" do
  it "should raise without valid options" do
    expect { get_compute.create_vm({}) }.to raise_error
  end

  it "should return the new VM's ID when creating" do
    res = get_compute.create_vm({'type' => "esx", 'template' => "precise64", 'memory' => 512})
    res["id"].should_not eql(nil)
  end
end
