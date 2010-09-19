require 'spec_helper'

describe "/admin/locations/show" do
  include LocationsHelper
  
  before(:each) do    
    assign(:location, @location = Factory(:location))
  end

  it "should succeed" do
    render
  end
end

