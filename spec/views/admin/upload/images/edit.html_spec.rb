require 'spec_helper'

describe "/admin_upload_images/edit" do
  include Admin::Upload::ImagesHelper
  
  before(:each) do
    assign(:image, @image = Factory(:image) )
  end
  
  it "should succeed" do
    render
  end

  it "should render edit form" do
    render
    
    rendered.should have_selector("form", :action => image_path(@image), :method=> 'post') do |form|
    end
  end
end


