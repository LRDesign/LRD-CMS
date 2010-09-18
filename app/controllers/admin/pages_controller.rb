class Admin::PagesController < ApplicationController
  # GET /admin/pages
  def index
    @pages = Page.all
  end

  # GET /admin/pages/1
  def show
    @page = Page.find(params[:id])
  end

  # GET /admin/pages/new
  def new
    @page = Page.new
  end

  # GET /admin/pages/1/edit
  def edit
    @page = Page.find(params[:id])
  end

  # POST /admin/pages
  def create
    @page = Page.new(params[:page])

    if @page.save
      redirect_to(admin_page_path(@page), :notice => 'Page was successfully created.') 
    else
      render :action => "new" 
    end
  end

  # PUT /admin/pages/1
  def update
    @page = Page.find(params[:id])

    if @page.update_attributes(params[:page])
      redirect_to(admin_page_path(@page), :notice => 'Page was successfully updated.')
    else
      render :action => "edit" 
    end
  end

  # DELETE /admin/pages/1
  def destroy
    @admin_page = Page.find(params[:id])
    @admin_page.destroy

    redirect_to(admin_pages_url)
  end
end
