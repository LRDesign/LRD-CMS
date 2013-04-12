require 'spec_helper'

describe "/admin/upload/images/index" do
  before(:each) do
    assign(:images, [ FactoryGirl.build(:image), FactoryGirl.build(:image) ])
  end

  it "should succeed" do
    render
  end
end

