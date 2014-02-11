class Admin::TopicsController < Admin::LocationsController
  private

  def human_name
    "Topic"
  end

  def location_scope
    Location.blog_topics
  end

  def location_params
    loc_parms = params.required(:location)

    loc_parms[:parent_id] = Location.topics_root.id
    #loc_parms[:path] = path_for(:controller => "topics", :action => "show",
    #:name => loc_parms[:name])

    loc_parms.permit(:name, :path, :parent_id)
  end
end
