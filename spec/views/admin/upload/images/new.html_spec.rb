require 'spec_helper'

describe "/admin/upload/images/new" do
  before(:each) do
    assign(:image, Image.new)
  end

  it "should succeed" do
    render
  end


  it "should render new form" do
    render
    rendered.should have_selector("form[action='#{admin_upload_images_path}'][method=post]")
  end
end


