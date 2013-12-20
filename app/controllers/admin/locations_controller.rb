class Admin::LocationsController < Admin::AdminController
  # GET /locations
  def index
    @locations = Location.all
  end


  # GET /locations/new
  def new
    @location = Location.new()
  end

  # GET /locations/1/edit
  def edit
    @location = Location.find(params[:id])
  end

  # POST /locations
  def create
    @location = Location.new(location_params)

    if @location.save
      expire_fragment(NAV_MENU_CACHE)
      flash[:notice] = 'Menu Entry was successfully created.'
      if params[:from_page]
        redirect_to(edit_admin_page_path(:id => @location.page_id))
      else
        redirect_to(admin_locations_path)
      end
    else
      render :action => "new"
    end
  end


  # PUT /locations/1
  def update
    @location = Location.find(params[:id])

    expire_fragment(NAV_MENU_CACHE)
    unless (move_to = params[:location].delete("move_to")).blank?
      Rails.logger.debug{"Moving [#{move_to}]: #{@location.to_text}"}
      if move_to == "last"
        @location.move_to_right_of(@location.siblings.last)
      else
        @location.move_to_left_of(move_to.to_i)
      end
      Rails.logger.debug{"Moved to #{@location.to_text}"}
    end

    if @location.update_attributes(location_params)
      flash[:notice] = 'Meny Entry was successfully updated.'
      redirect_to(admin_locations_path)
    else
      render :action => 'edit'
    end
  end

  # DELETE /locations/1
  def destroy
    @location = Location.find(params[:id])
    @location.destroy

    redirect_to(admin_locations_url)
  end

  def location_params
    params[:location].permit(:name, :path, :parent_id, :page_id, :parent, :page)
  end
end
