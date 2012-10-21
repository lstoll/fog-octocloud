require "helper"

# TODO - Global vars are so bad. Do this better.

describe "TemplateRequests" do
  describe "CreateRequest" do
    it "should create a template and return it's ID" do
      res = get_compute.create_template({'name' => "test-template", 'image-urls' => {"test" => "http://test/test.vmdk"}})
      $template_id = res["id"]
      $template_id.should_not eql(nil)
    end
  end

  describe "ListRequest" do
    it "should list the created template" do
      res = get_compute.list_templates
      res.any? {|v| v["id"].to_s == $template_id.to_s}.should eql(true)
    end
  end

  describe "GetRequest" do
    it "successfully retrieves the template" do
      get_compute.get_template($template_id).should_not eql(nil)
    end
  end

  describe "UpdateTemplaes" do
    it "should bump the revision number on updating" do
      res = {}
      get_compute.update_template $template_id, {}
      get_compute.get_template($template_id)['revision'].should eql(2)
    end
  end

  describe "DeleteRequest" do
    it "should successfully remove the template" do
      get_compute.delete_template $template_id
      res = get_compute.list_templates
      res.any? {|v| v["id"].to_s == $template_id.to_s}.should_not eql(true)
    end
  end
end
