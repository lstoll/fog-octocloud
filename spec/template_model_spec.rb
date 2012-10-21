require "helper"

# TODO - Global vars are so bad. Do this better.

describe "ModelRequests" do
  describe "CreateRequest" do
    it "successfully creates a server" do
      res = get_compute.templates.create({:name => "test-template", :image_urls => {:test => "http://test/test.vmdk"}})
      $template_id = res.identity
      res.should_not eql(nil)
    end
  end

  describe "ListRequest" do
    it "should list the created template" do
      res = get_compute.templates
      res.any? {|v| v.identity.to_s == $template_id.to_s}.should eql(true)
    end
  end

  describe "GetRequest" do
    it "successfully retrieves the template" do
      get_compute.templates.get($template_id).should_not eql(nil)
    end
  end

  describe "UpdateTemplates" do
    it "should bump the revision number on updating" do
      t = get_compute.templates.get $template_id
      t.save
      t.revision.should eql(2)
    end
  end

  describe "DeleteRequest" do
    it "should successfully remove the template" do
      get_compute.templates.get($template_id).destroy
      get_compute.templates.any? {|v| v.identity.to_s == $template_id.to_s}.should_not eql(true)
    end
  end
end
