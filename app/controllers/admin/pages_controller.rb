class Admin::PagesController < Admin::AdminController
  # GET /admin/pages
  def index
    @pages = page_scope.all
  end

  # GET /admin/pages/new
  def new
    @page = Page.new
  end

  # GET /admin/pages/1/edit
  def edit
    @page = page_scope.find(params[:id])
  end

  # POST /admin/pages
  def create
    @page = Page.new(page_attrs)

    if @page.save
      redirect_to(page_path(@page), :notice => 'Page was successfully created.')
    else
      render :action => "new"
    end
  end

  # PUT /admin/pages/1
  def update
    @page = page_scope.find(params[:id])

    location_handling

    if @page.update_attributes(page_attrs)
      if @page.permalink == 'home'
        redirect_to(root_url, :notice => 'Page was successfully updated.')
      else
        redirect_to(page_path(@page), :notice => 'Page was successfully updated.')
      end
    else
      render :action => "edit"
    end
  end

  # DELETE /admin/pages/1
  def destroy
    @admin_page = page_scope.find(params[:id])
    @admin_page.destroy

    redirect_to(admin_pages_url)
  end

  # def page_path(page)
  #   "/#{page.permalink}"
  # end
  #
  private

  def location_handling
  end

  def page_layout
    nil
  end

  def page_scope
    Page.brochure
  end

  def page_params
    @page_params ||= params.required(:page).tap do |page_params|

    if page_params.delete(:published)
      page_params[:published_start] = Time.at(0)
    else
      page_params[:published_end] = Time.at(0)
    end

      page_params[:layout] = page_layout
    end
  end

  def page_attrs
    page_params.permit(:title, :permalink, :content, :edited_at, :description,
                      :headline, :keywords, :publish_start, :publish_end, :layout, :css)
  end
end
