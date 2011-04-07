require 'spec_helper'

describe PagesController do
  describe "routing" do
    it "routes permalink to the page show" do
      @page = Factory(:page, :permalink => 'foo')
      { :get => "/foo" }.should route_to(:controller => "pages", :action => "show", :permalink => 'foo')
    end
  end
end
