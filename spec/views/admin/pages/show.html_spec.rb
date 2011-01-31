require 'spec_helper'

describe "/admin/pages/show" do

  before(:each) do
    activate_authlogic
    assign(:page, @page = Factory(:page))
  end

  it "should succeed" do
    render
  end
end

