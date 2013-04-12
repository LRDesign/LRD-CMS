require 'spec_helper'

describe "/admin/pages/index" do

  before(:each) do
    assign(:pages, [ FactoryGirl.build(:page), FactoryGirl.build(:page) ])
  end

  it "should succeed" do
    render
  end
end

