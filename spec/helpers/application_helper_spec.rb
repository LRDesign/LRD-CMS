require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the ApplicationHelper. For example:
#
# describe ApplicationHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe ApplicationHelper do
  describe "link tree generation" do
    describe "with nil base location" do
      it "returns an empty string" do
        helper.link_tree(nil).should == ""
      end
    end

    describe "with no base location children" do 
      before(:each) do 
        @loc = Factory(:location)
      end

      it "returns an empty string" do
        helper.link_tree(nil).should == ""
      end
    end

    describe "with single-child depth of 1 location" do
      before(:each) do
        @loc = Factory(:location_with_single_child)
        @child = @loc.children.first
        helper.view_context.should_receive(:render).with( 
            :partial => 'test', 
            :locals => {:location => @child, 
                        :children => []}).and_return('test value')
      end

      it "renders the partial once for a single location" do
        helper.link_tree(@loc, :partial => 'test')
      end

      it "returns nothing more than what the partial rendered" do
        helper.link_tree(@loc, :partial => 'test').should == 'test value'
      end
    end
  end

  describe "location path" do
    describe "when attached to page" do
      before(:each) do 
        @loc = Factory(:location_with_page)
      end

      it "uses page permalink" do
        helper.loc_path(@loc).should == "/" + @loc.page.permalink
      end
    end

    describe "when not attached to page" do
      before(:each) do
        @loc = Factory(:location_without_page)
      end

      it "uses loc.path" do
        helper.loc_path(@loc).should == @loc.path 
      end
    end
  end
end
