require 'spec_helper'

describe "/admin/locations/index" do
  include LocationsHelper

  before(:each) do
    assign(:locations, [ FactoryGirl.build(:location), FactoryGirl.build(:location) ])
  end

  it "should succeed" do
    render
  end
end

