class Admin::PagesController < Admin::AdminController
  uses_tiny_mce :options => {
    :theme => 'advanced',
    :theme_advanced_resizing => true,
    :theme_advanced_resize_horizontal => false,
    :plugins => %w{ table fullscreen }
  }
  # GET /admin/pages
  def index
    @pages = Page.all
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
      redirect_to(page_path(@page), :notice => 'Page was successfully created.')
    else
      render :action => "new"
    end
  end

  # PUT /admin/pages/1
  def update
    @page = Page.find(params[:id])

    if @page.update_attributes(params[:page])
      redirect_to(page_path(@page), :notice => 'Page was successfully updated.')
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

  # def page_path(page)
  #   "/#{page.permalink}"
  # end
end
