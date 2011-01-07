require 'spec_helper'

describe Page do
  describe "mass assignment" do
    it "should mass assign title and permalink" do
      page = Page.new(:title => 'foo', :permalink => 'bar' )
      page.title.should == 'foo'
      page.permalink.should == 'bar'
    end
  end

  describe "validations" do
    describe "uniqueness" do
      it "should not create two pages with the same title" do
        page_1 = Factory.create(:page, :title => 'foo')
        page_2 = Factory.build(:page, :title => 'foo')
        page_2.should_not be_valid
      end
      it "should not create two pages with the same permalink" do
        page_1 = Factory.create(:page, :permalink => 'foo')
        page_2 = Factory.build(:page, :permalink => 'foo')
        page_2.should_not be_valid
      end
    end
  end

  describe "published scope" do
    before :each do
      @page_1 = Factory(:page, :published => true)
      @page_2 = Factory(:page, :published => false)
    end
    it "should include a published page" do
      Page.published.should include @page_1
    end
    it "should not include an unpublished page" do
      Page.published.should_not include @page_2
    end
  end
end
