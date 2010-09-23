require 'spec_helper'

describe PagesController do

  before(:each) do
    @page = Factory(:page)
    @unpublished_page = Factory(:unpublished_page)
  end

  ########################################################################################
  #                                      GET SHOW
  ########################################################################################
  describe "responding to GET show" do
    it "should expose the requested published page as @page" do
      get :show, :permalink => @page.permalink
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
        get :show, 
            :permalink => @unpublished_page.permalink 
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
