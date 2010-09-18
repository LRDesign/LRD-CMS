require 'spec_helper'

describe "/admin/pages/index" do
  include Admin::PagesHelper
  
  before(:each) do 
    assign(:pages, [ Factory(:page), Factory(:page) ])
  end                   

  it "should succeed" do
    render
  end
end

