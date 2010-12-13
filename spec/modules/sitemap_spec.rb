require 'sitemap'

describe Sitemap do
  describe "with no pages" do 
    it "should not crash" do
      Sitemap.create!
    end
  end
 
  describe "with a couple pages" do
    before(:each) do
      @page_public = Factory(:page, :published => true)
      @page_private = Factory(:page, :published => false)
    end

    it "should not crash" do
      Sitemap.create!
    end
  end
end
