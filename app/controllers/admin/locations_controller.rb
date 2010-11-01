class Admin::LocationsController < Admin::AdminController
  # GET /locations
  def index
    @locations = Location.roots.all
  end

  # GET /locations/new
  def new
    @location = Location.new
  end

  # GET /locations/1/edit
  def edit
    @location = Location.find(params[:id])
  end

  # POST /locations
  def create
    @location = Location.new(params[:location])

    if @location.save
      flash[:notice] = 'Location was successfully created.'
      redirect_to(admin_location_path(@location), :notice => 'Location was successfully created.')
    else
      render :action => "new"
    end
  end

  # PUT /locations/1
  def update
    @location = Location.find(params[:id])
    move_to = params[:location].delete("move_to")

    if !move_to.to_s.empty?
      Rails.logger.debug{"Moving [#{move_to}]: #{@location.to_text}"}
      if move_to == "last"
        @location.move_to_right_of(@location.siblings.last)
      else
        @location.move_to_left_of(move_to.to_i)
      end
      Rails.logger.debug{"Moved to #{@location.to_text}"}
    end

    if @location.update_attributes(params[:location])
      redirect_to(admin_location_path(@location), :notice => 'Location was successfully updated.')
    else
      render :action => "edit"
    end
  end

  # DELETE /locations/1
  def destroy
    @location = Location.find(params[:id])
    @location.destroy

    redirect_to(admin_locations_url)
  end
end
