module ApplicationHelper    
  include AuthenticatedSystem
 
  def nav_menu(root_name)
    Rails.logger.info "******************* Nav menu for #{root_name}"
    location_tree(root_name, :html => {:id => 'nav_menu'}, :partial => 'shared/nav_subtree')
  end

  def location_tree(root_name, options)             
    home_location = Location.roots.first(:conditions => {:name => root_name})      
    html_attributes = options[:html] || {}
      
    content_tag(:ul, html_attributes) do
      link_tree(home_location, options)
    end    
  end

  def link_tree(location, options=nil)
    return "" unless location

    options ||= {}
    max_depth = options[:max_depth]
    partial = options[:partial] || "shared/location_subtree"
    stack = [[]]
    Location.each_with_level(location.descendants.all(:include => :page)) do |location, depth|
      next unless max_depth.nil? or depth <= max_depth

      if depth <= stack.length and not stack.last.empty?
        stack.last.push(render :partial => partial, :locals => { :location => stack.last.pop, :children => [] })
      end

      while depth > stack.length
        stack.push []
      end

      while depth < stack.length
        group = stack.pop
        stack.last.push(render :partial => partial, :locals => { :location => stack.last.pop, :children => group })
      end

      stack.last << location
    end

    unless stack.last.empty?
      stack.last.push(render :partial => partial, :locals => { :location => stack.last.pop, :children => [] })
    end
    stack.last.join
  end 

  def admin?
    logged_in?
  end
  
  def loc_path(loc)
    loc.page ? "/#{loc.page.permalink}" : loc.path
  end
end
