require 'spec_helper'

describe TreeHelper do
  # a-+-b---c---d
  #   +-e
  #   \-f-+-g
  #       \-h
  let (:a) { Factory(:location, :path => "a", :name => "a") }
  let (:b) { Factory(:location, :path => "b", :name => "b", :parent => a) }
  let (:c) { Factory(:location, :path => "c", :name => "c", :parent => b) }
  let!(:d) { Factory(:location, :path => "d", :name => "d", :parent => c) }
  let!(:e) { Factory(:location, :path => "e", :name => "e", :parent => a) }
  let (:f) { Factory(:location, :path => "f", :name => "f", :parent => a) }
  let!(:g) { Factory(:location, :path => "g", :name => "g", :parent => f) }
  let!(:h) { Factory(:location, :path => "h", :name => "h", :parent => f) }

  it "should produce a correct tree for a node with no childen" do
    list_tree("shared/test_nav_node", "shared/test_nav_list", d.reload.descendants.all(:include => :page)).should match_dom_of <<-EOD
<ul>
</ul>
    EOD
  end

  it "should produce a correct tree for a parent of a big tree" do
    list_tree("shared/test_nav_node", "shared/test_nav_list", a.reload.descendants.all(:include => :page)).should match_dom_of <<-EOD
<ul>
<li>
<a href="b">b</a>
<ul>
<li>
<a href="c">c</a>
<ul>
<li>
<a href="d">d</a>
</li>

</ul>

</li>

</ul>

</li>

<li>
<a href="e">e</a>
</li>

<li>
<a href="f">f</a>
<ul>
<li>
<a href="g">g</a>
</li>

<li>
<a href="h">h</a>
</li>

</ul>

</li>

</ul>
    EOD
  end
end
