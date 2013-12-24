require 'spec_helper'

describe "/admin/locations/new" do
  include LocationsHelper

  it "should succeed" do
    render
  end

  it "should render new form" do
    render
    rendered.should have_selector("form")
  end
end


