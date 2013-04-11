class Admin::LocationsController < Admin::AdminController
  # GET /locations
  def index
    @locations = Location.all
  end

  # GET /locations/1
  def show
    @location = Location.find(params[:id])
  end

  # GET /locations/new
  def new
    @location = Location.new(params[:location])
  end

  # GET /locations/1/edit
  def edit
    @location = Location.find(params[:id])
  end

  # POST /locations
  def create
    @location = Location.new(params[:location])

    if @location.save
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

    unless (move_to = params[:location].delete("move_to")).blank?
      Rails.logger.debug{"Moving [#{move_to}]: #{@location.to_text}"}
      if move_to == "last"
        @location.move_to_right_of(@location.siblings.last)
      else
        @location.move_to_left_of(move_to.to_i)
      end
      Rails.logger.debug{"Moved to #{@location.to_text}"}
    end

    if @location.update_attributes(params[:location])
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
end
