require "helper"

# TODO - Global vars are so bad. Do this better.

describe "ModelRequests" do
  describe "CreateRequest" do
    it "successfully creates a server" do
      res = get_compute.cubes.create({:name => "test-cube", :url => "http://test/test.vmdk"})
      $cube_id = res.identity
      res.should_not eql(nil)
    end
  end

  describe "ListRequest" do
    it "should list the created cube" do
      res = get_compute.cubes
      res.any? {|v| v.identity.to_s == $cube_id.to_s}.should eql(true)
    end
  end

  describe "GetRequest" do
    it "successfully retrieves the cube" do
      get_compute.cubes.get($cube_id).should_not eql(nil)
    end
  end

  describe "UpdateCubes" do
    it "should bump the revision number on updating" do
      t = get_compute.cubes.get $cube_id
      t.save
      t.revision.should eql(2)
    end
  end

  describe "DeleteRequest" do
    it "should successfully remove the cube" do
      get_compute.cubes.get($cube_id).destroy
      get_compute.cubes.any? {|v| v.identity.to_s == $cube_id.to_s}.should_not eql(true)
    end
  end
end
