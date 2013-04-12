require 'spec_helper'

describe "/admin/upload/images/index" do
  before(:each) do
    assign(:images, [ FactoryGirl.create(:image), FactoryGirl.create(:image) ])
  end

  it "should succeed" do
    render
  end
end

