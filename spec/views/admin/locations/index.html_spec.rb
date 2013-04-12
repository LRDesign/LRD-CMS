require 'spec_helper'

describe "/admin/locations/index" do
  include LocationsHelper

  before(:each) do
    assign(:locations, [ FactoryGirl.create(:location), FactoryGirl.create(:location) ])
  end

  it "should succeed" do
    render
  end
end

