require 'spec_helper'

describe "/admin/locations/new" do
  include LocationsHelper

  before(:each) do
    assign(:location, FactoryGirl.build(:location))
  end

  it "should succeed" do
    render
  end


  it "should render new form" do
    render

    rendered.should have_selector("form", :action => admin_locations_path, :method=> 'post')
  end
end


