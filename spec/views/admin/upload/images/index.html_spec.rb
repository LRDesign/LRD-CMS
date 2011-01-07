require 'spec_helper'

describe "/admin/upload/images/index" do
  before(:each) do
    assign(:images, [ Factory(:image), Factory(:image) ])
  end

  it "should succeed" do
    render
  end
end

