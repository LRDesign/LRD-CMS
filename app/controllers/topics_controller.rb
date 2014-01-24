class TopicsController < ApplicationController
  def index
    @topics = Location.blog_topics
    @posts = Page.most_recent.published.blog
  end

  def show
    topic_ids = Location.blog_topics.where(:name => params[:name]).descendants.map(&:id)
    @posts = Page.where(:location_id => topic_ids)
  end
end
