require 'spec_helper'

describe "/admin/locations/index" do
  include LocationsHelper

  let!(:location) { FactoryGirl.create(:location)  }
  before do assign(:location, location)  end

  it "should succeed" do
    render
  end
end

