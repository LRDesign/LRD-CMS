class Admin::PagesController < Admin::AdminController
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
    @page = Page.new(page_params)

    if @page.save
      redirect_to(page_path(@page), :notice => 'Page was successfully created.')
    else
      render :action => "new"
    end
  end

  # PUT /admin/pages/1
  def update
    @page = Page.find(params[:id])

    if @page.update_attributes(page_params)
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
  #

  def page_params
    page_params = params.required(:page)

    if page_params.delete(:published)
      page_params[:published_start] = Time.at(0)
    else
      page_params[:published_end] = Time.at(0)
    end

    page_params.permit(:title, :permalink, :content, :edited_at, :description,
                      :headline, :keywords, :publish_start, :publish_end, :css)
  end
end
