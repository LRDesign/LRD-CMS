require 'authenticated_system'

module ApplicationHelper
  include AuthenticatedSystem

  def nav_menu(root_name)
    location_tree(root_name, :html => {:id => 'nav_menu'}, :partial => 'shared/nav_subtree')
  end

  def location_tree(root_name, options)
    home_location = Location.roots.first(:conditions => {:name => root_name})
    html_attributes = options[:html] || {}

    content_tag(:ul, html_attributes) do
      link_tree(home_location, options)
    end
  end

  # Never Again.
  def link_tree(location, options=nil)
    return "" unless location

    options ||= {}
    max_depth = options[:max_depth] || 5
    partial = options[:partial] || "shared/location_subtree"
    loc_tree = []
    max_depth.times do
      loc_tree << {}
    end
    render_tree = {}

    Location.each_with_level(location.descendants.all(:include => :page)) do |loc, depth|
      next if depth >= max_depth

      if loc_tree[depth][loc.parent_id]
        loc_tree[depth][loc.parent_id] << loc
      else
        loc_tree[depth][loc.parent_id] = [loc]
      end
    end

    # Find the highest depth leaves
    current_depth_leaves = loc_tree.last
    while loc_tree.last.empty?
      current_depth_leaves = loc_tree.pop
    end

    current_depth_leaves = loc_tree.pop

    while !current_depth_leaves.empty? && !loc_tree.empty?
      current_depth_leaves.each do |parent_id, leaves|
        leaves.each do |leaf|
          children = render_tree[leaf.id] || []
          if render_tree[parent_id]
            render_tree[parent_id] << render(:partial => partial, :locals => {:location => leaf, :children => children})
          else
            render_tree[parent_id] = [ render(:partial => partial, :locals => {:location => leaf, :children => children}) ]
          end
        end
      end
      current_depth_leaves = loc_tree.pop
    end

    render_tree_root_node = render_tree[location.id]
    render_tree_root_node.join
  end

  def admin?
    logged_in?
  end

  def loc_path(loc)
    loc.page ? "/#{loc.page.permalink}" : loc.path
  end
end
