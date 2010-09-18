require 'spec_helper'

describe "/admin/upload/images/show" do
  include Admin::Upload::ImagesHelper
  
  before(:each) do    
    assign(:image, @image = Factory(:image))
  end

  it "should succeed" do
    render
  end
end

