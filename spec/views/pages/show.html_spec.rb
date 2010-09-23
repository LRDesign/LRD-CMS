require 'spec_helper'

describe "/pages/show" do
  before(:each) do    
    assign(:page, @page = Factory(:page))
  end

  it "should succeed" do
    render
  end
end

