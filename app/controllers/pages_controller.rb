class PagesController < ApplicationController
  # GET /:prefix/*permalink
  def show
    path = params[:permalink].unshift(params[:prefix]).join("/")
    @page = Page.find_by_permalink(path)
    if @page.nil?
      Rails.logger.info{"Returning 404 for #{path}"}
      render "public/404.html", :status => 404
    end
  end
end
