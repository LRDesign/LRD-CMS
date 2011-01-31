require 'spec_helper'

describe "/admin/pages/edit" do

  before(:each) do
    assign(:page, @page = Factory(:page) )
  end

  it "should succeed" do
    render
  end

  describe "edit form" do
    before :each do
      render
    end
    it "should render" do
      rendered.should have_selector("form", :action => admin_page_path(@page), :method=> 'post')
    end
    it "should have a css block in a collapsed div" do
      rendered.should have_selector("form", :action => admin_page_path(@page), :method=> 'post') do |scope|
        scope.should have_selector("div", :class => 'collapsed')
        scope.should have_selector('textarea', :name => 'page[css]')
      end
    end

  end
end


