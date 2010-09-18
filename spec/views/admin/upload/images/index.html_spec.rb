require 'spec_helper'

describe "/admin_upload_images/index" do
  include Admin::Upload::ImagesHelper
  
  before(:each) do 
    assign(:images, [ Factory(:image), Factory(:image) ])
  end                   

  it "should succeed" do
    render
  end
end

