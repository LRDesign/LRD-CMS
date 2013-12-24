require 'spec_helper'

describe "/admin/locations/new" do
  include LocationsHelper

  before do
    assign(:location, Location.new)
  end

  it "should succeed" do
    render
  end

  it "should render new form" do
    render
    rendered.should have_selector("form")
  end
end


