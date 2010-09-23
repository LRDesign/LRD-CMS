require 'spec_helper'

describe "/admin/pages/edit" do
  
  before(:each) do
    assign(:page, @page = Factory(:page) )
  end
  
  it "should succeed" do
    render
  end

  it "should render edit form" do
    render
    
    rendered.should have_selector("form", :action => admin_page_path(@page), :method=> 'post') do |form|
    end
  end
end


