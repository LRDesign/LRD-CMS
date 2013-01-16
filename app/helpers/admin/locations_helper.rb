module Admin::LocationsHelper
  def location_parent_selector(form)
    form.select(:parent_id, 
      Location.find(:all).collect  {|p| [p.name, p.id]}, { :include_blank => "" }
    )     
  end

  def sibling_selector(form)
    positions = [""]
    positions += @location.siblings.map {|sib| ["Before: " + sib.name, sib.id]}
    positions << ["Last", "last"]

    select_tag("location[move_to]", options_for_select(positions))
  end

  def  page_selector(form)
    form.select(:page_id,
      Page.find(:all).collect { |c| [c.title, c.id]}, { :include_blank => "" }
    )    
  end

  def list_tree(locations, add_depth = 0)
    str = ''
    [*locations].each do |location|
      Location.each_with_level(location.self_and_descendants) do |location, depth|
        str << (render :partial => "admin/locations/location", :locals => { :location => location, :depth => depth + add_depth })
      end
    end
    str.html_safe
  end

  def depth_indicator(depth)
    str = ''
    if depth > 0 
      depth.times do
        str << image_tag("/images/icons/spacer.png", :class=> "inline", :size =>"20x12", :alt => "&nbsp;&nbsp;&nbsp;")
      end
      str << image_tag("/images/icons/indent_arrow.png", :class=>"inline", :size => "12x12", :alt => '->')
    end
    str.html_safe
  end
end
