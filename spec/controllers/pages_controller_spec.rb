require 'spec_helper'

describe PagesController do

  before(:each) do
    @page = Factory(:page)
    @page_permalink_without_prefix = @page.permalink.sub(/test\//,'')
  end

  ########################################################################################
  #                                      GET SHOW
  ########################################################################################
  describe "responding to GET show" do
    it "should expose the requested page as @page" do
      get :show, :prefix => 'test', :permalink => [@page_permalink_without_prefix]
      assigns[:page].should == @page
    end  
  end
end
