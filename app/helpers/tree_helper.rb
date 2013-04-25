module TreeHelper
  #I hate to have to comment in here but, it's tricky.
  #This method takes a list of nodes in tree-order and produces a templated
  #tree of elements without making further SQL queries
  #
  #node_partial: the Rails-style path to a partial for each node in the tree
  #list_partial: the Rails-style path to a partial for collecting the children
  #of a node into a list'
  #nodes: the list of node in tree order
  def list_tree(node_partial, list_partial, nodes)
    TreeLister.new(self, nodes, node_partial, list_partial).render
  end


  class TreeLister
    #Can we search for the partials once and cache that?
    def initialize(view, nodes, node_partial, list_partial)
      @view = view
      @nodes = nodes
      @node_partial = node_partial
      @list_partial = list_partial
      @stack = [[]]
      @path = []
    end

    def pop_level
      depth = @path.length
      children = (@view.render :partial => @list_partial, :locals => {:items => @stack.pop, :depth => depth })
      @stack.last << (@view.render :partial => @node_partial, :locals => { :node => @path.pop, :children => children, :depth => depth})
    end

    def render
      (@nodes + [nil]).each_cons(2) do |this, after|
        until @path.empty? or @path.last.is_ancestor_of?(this)
          pop_level
        end
        if after.nil? or !this.is_ancestor_of?(after)
          @stack.last << (@view.render :partial => @node_partial, :locals => { :node => this, :depth => @path.length })
        else
          @path << this
          @stack << []
        end
      end
      until @path.empty?
        pop_level
      end
      return @view.render(:partial => @list_partial, :locals => {:items => @stack.last, :top_level => true, :depth => 0}).html_safe
    end
  end

  def nav_menu(root_name)
    location_tree(root_name)
  end

  def location_tree(root_name, options=nil)
    home_location = Location.first(:conditions => {:name => root_name})

    return "" unless home_location
    Rails.logger.debug{ "Location tree being build from #{home_location.inspect}" }

    list_tree("shared/nav_node", "shared/nav_list", home_location.descendants.all(:include => :page))
  end

  def bottom_nav_menu(root_name)
    home_location = Location.first(:conditions => {:name => root_name})

    return "" unless home_location
    Rails.logger.debug{ "Location tree being build from #{home_location.inspect}" }

    list_tree("shared/bottom_nav_node", "shared/bottom_nav_list", home_location.descendants.all(:include => :page))
  end

  def nav_menu_link(node)
    if (loc_path(node).include?("http"))
      link_to(node.name, loc_path(node), :class => active_class(node), :target => :new)
    else
      link_to(node.name, loc_path(node), :class => active_class(node))
    end
  end
end
