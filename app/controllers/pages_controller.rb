class PagesController < ApplicationController
  # GET /:prefix/*permalink
  def show
    path = params[:permalink]
    @page = Page.find_by_permalink(path)
    if @page.nil? || !@page.published?
      # If the page is unpublished, we don't want to expose it
      # to the view even if it won't be rendered.
      @page = nil
      Rails.logger.info{"Returning 404 for #{path}"}
      render "public/404.html", :status => 404
    end
    @title = @page.title if @page
  end
end
