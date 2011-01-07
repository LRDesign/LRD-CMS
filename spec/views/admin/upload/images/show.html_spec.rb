require 'spec_helper'

describe "/admin/upload/images/show" do
  before(:each) do
    assign(:image, @image = Factory(:image))
  end

  it "should succeed" do
    render
  end
end

