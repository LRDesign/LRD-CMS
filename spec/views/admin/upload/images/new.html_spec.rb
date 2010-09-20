require 'spec_helper'

describe "/admin/upload/images/new" do
  include Admin::Upload::ImagesHelper
  
  before(:each) do    
    assign(:image, Factory.build(:image))
  end
  
  it "should succeed" do
    render
  end
  

  it "should render new form" do
    render                                          
    rendered.should have_selector("form", :action => admin_upload_images_path, :method=> 'post')
  end
end


