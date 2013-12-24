require 'spec_helper'

describe "/admin/locations/index" do
  include LocationsHelper

  let!(:location) { FactoryGirl.create(:location)  }
  before { assign(:location, location) }

  it "should succeed" do
    render
  end
end

