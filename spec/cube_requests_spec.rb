require "helper"

# TODO - Global vars are so bad. Do this better.

describe "CubeRequests" do
  describe "CreateRequest" do
    it "should create a cube and return it's ID" do
      res = get_compute.create_cube({'name' => "test-cube", 'url' => "http://test/test.vmdk"})
      $cube_id = res["id"]
      $cube_id.should_not eql(nil)
    end
  end

  describe "ListRequest" do
    it "should list the created cube" do
      res = get_compute.list_cubes
      res.any? {|v| v["id"].to_s == $cube_id.to_s}.should eql(true)
    end
  end

  describe "GetRequest" do
    it "successfully retrieves the cube" do
      get_compute.get_cube($cube_id).should_not eql(nil)
    end
  end

  describe "UpdateTemplaes" do
    it "should bump the revision number on updating" do
      res = {}
      get_compute.update_cube $cube_id, {}
      get_compute.get_cube($cube_id)['revision'].should eql(2)
    end
  end

  describe "DeleteRequest" do
    it "should successfully remove the cube" do
      get_compute.delete_cube $cube_id
      res = get_compute.list_cubes
      res.any? {|v| v["id"].to_s == $cube_id.to_s}.should_not eql(true)
    end
  end
end
