require 'spec_helper'

describe PagesController do

  before(:each) do
    @page = Factory(:page)
    @page_permalink_without_prefix = @page.permalink.sub(/test\//,'')

    @unpublished_page = Factory(:unpublished_page)
    @unpub_page_permalink_without_prefix = @unpublished_page.permalink.sub(/test\//,'')
  end

  ########################################################################################
  #                                      GET SHOW
  ########################################################################################
  describe "responding to GET show" do
    it "should expose the requested published page as @page" do
      get :show, :prefix => 'test', :permalink => @page_permalink_without_prefix
      assigns[:page].should == @page
    end  

    describe "for a non-existent page" do
      it "should return status 404" do
        get :show, :prefix => 'test', :permalink => "how_do_we_know_that_we_truly_exist"
        response.status.should == 404
      end
    end

    describe "for an unpublished page" do
      before(:each) do
        get :show, :prefix => 'test', 
            :permalink => @unpub_page_permalink_without_prefix 
      end
      it "should not expose the page as @page" do
        assigns[:page].should == nil
      end
      it "should return status 404" do
        response.status.should == 404
      end
    end
  end
end
