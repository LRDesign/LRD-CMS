require 'spec_helper'

describe "/admin/locations/edit" do
  include LocationsHelper

  before(:each) do
    assign(:location, @location = FactoryGirl.create(:location) )
  end

  it "should succeed" do
    render
  end

  it "should render edit form" do
    render

    rendered.should have_selector("form", :action => admin_location_path(@location), :method=> 'post')
  end
end


