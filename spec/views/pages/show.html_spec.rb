require 'spec_helper'

describe "/pages/show" do
  include PagesHelper
  
  before(:each) do    
    assign(:page, @page = Factory(:page))
  end

  it "should succeed" do
    render
  end
end

