require 'spec_helper'


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
        # Test is in the message expectation
        helper.link_tree(@loc, :partial => 'test')
      end

      it "returns nothing more than what the partial rendered" do
        helper.link_tree(@loc, :partial => 'test').should == 'test value'
      end
    end

    describe "with 1 < depth < max_depth" do
      describe "peerless direct children of root node" do
        before(:each) do
          @loc = Factory(:location_with_children_2_deep)
          @loc.reload
          @child = @loc.children.first
          @sub_child = @child.children.first
          @options = { :max_depth => 3, :partial => 'test' }
        end

        it "renders the partial for the child and subchild" do
          helper.view_context.should_receive(:render).with(
              {:partial => 'test',
              :locals => {:location => @child,
                          :children => ["foo"]}}, {}).and_return('foo')
          helper.view_context.should_receive(:render).with(
              {:partial => 'test',
              :locals => {:location => @sub_child,
                          :children => []}}, {}).and_return('foo')

          link_tree(@loc, @options)
        end

        it "returns the concatenation of the renderings" do
          helper.view_context.should_receive(:render).with(
              {:partial => 'test',
              :locals => {:location => @child,
                          :children => ["2"]}}, {}).and_return('1')
          helper.view_context.should_receive(:render).with(
              {:partial => 'test',
              :locals => {:location => @sub_child,
                          :children => []}}, {}).and_return('2')

          link_tree(@loc, @options).should == '1'
        end
      end
    end

    describe "children of root node with peers and sub-children" do
      before(:each) do
        @root = Factory(:location_with_2_children_each_with_2_children)
        @root.reload
        @options = { :max_depth => 3, :partial => 'test' }
      end

      it "renders the partial 6 times (2 for children, 4 for sub-children)" do
        helper.view_context.should_receive(:render).exactly(6).times.and_return('foo')
        link_tree(@root, @options)
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
